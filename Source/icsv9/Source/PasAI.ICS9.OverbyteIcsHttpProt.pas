{*_* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

Author:       Fran�ois PIETTE
Creation:     November 23, 1997
Version:      V9.0
Description:  THttpCli is an implementation for the HTTP protocol
              RFC 1945 (V1.0), and some of RFC 2068 (V1.1)
Credit:       This component was based on a freeware from by Andreas
              Hoerstemeier and used with his permission.
              andy@hoerstemeier.de http://www.hoerstemeier.com/index.htm
EMail:        francois.piette@overbyte.be         http://www.overbyte.be
Support:      https://en.delphipraxis.net/forum/37-ics-internet-component-suite/
Legal issues: Copyright (C) 1997-2023 by Fran�ois PIETTE
              Rue de Grady 24, 4053 Embourg, Belgium.
              SSL implementation includes code written by Arno Garrels,
              Berlin, Germany

              This software is provided 'as-is', without any express or
              implied warranty.  In no event will the author be held liable
              for any  damages arising from the use of this software.

              Permission is granted to anyone to use this software for any
              purpose, including commercial applications, and to alter it
              and redistribute it freely, subject to the following
              restrictions:

              1. The origin of this software must not be misrepresented,
                 you must not claim that you wrote the original software.
                 If you use this software in a product, an acknowledgment
                 in the product documentation would be appreciated but is
                 not required.

              2. Altered source versions must be plainly marked as such, and
                 must not be misrepresented as being the original software.

              3. This notice may not be removed or altered from any source
                 distribution.

              4. You must register this software by sending a picture postcard
                 to the author. Use a nice stamp and mention your name, street
                 address, EMail address and any comment you like to say.

Quick Reference:
HTTP component can retrieve documents or files using HTTP protocol; that is
connect to a HTTP server also known as a webserver. It can also trigger a
CGI/ISAPI/NSAPI script and post data using either GET or POST method.
Syntax of an URL: protocol://[user[:password]@]server[:port]/path
Path can include data: question mark followed by URL encoded data.
HTTP component is either asynchonous (non-blocking) or synchonous (blocking).
Highest performance is when using asynchonous operation. This is the
recommended way to use HTTP component.
To request several URL simultaneously, use asynchronous operation and as much
HTTP components as you wants to request URLs. All requests will be executed
simultaneously without using multi-threading and without blocking your app.
Methods:
    GetASync    Asynchronous, non-blocking Get
                Retrieve document or file specified by URL, without blocking.
                OnRequestDone event trigered when finished. Use HTTP GET
                method (data contained in URL)
    PostASync   Asynchronous, non-blocking Post
                Retrieve document or file specified by URL, without blocking.
                OnRequestDone event trigered when finished. Use HTTP POST
                method (data contained in request stream)
    HeadASync   Asynchronous, non-blocking Head
                Retrieve document or file header specified by URL, without
                blocking. OnRequestDone event trigered when finished. Use HTTP
                HEAD method.

    Get         Synchronous, blocking Get. Same as GetAsync, but blocks until
                finished.
    Post        Synchronous, blocking Post. Same as PostAsync, but blocks until
                finished.
    Head        Synchronous, blocking Head. Same as HeadAsync, but blocks until
                finished.
    Abort       Immediately close communication.

Updates:
11/29/97 RcvdStream and SendStream properties moved to public section
11/30/97 Document name bug corrected
12/02/97 Removed bug occuring with terminating slash in docname
12/03/97 Added properties RcvdCount and SentCount to easily add a progress
         bar feature (On receive, the ContentLength is initialized with the
         value from the header. Update the progress bar in the OnDocData event,
         or the OnSendData event).
         Added the OnSendBegin, OnSendData and OnSendEnd events.
12/07/97 Corrected Head function to work as expected. Thanks to
         R. Barry Jones <rbjones@therightside.demon.co.uk
29/12/97 V0.96 Added ModifiedSince property as following proposition made by
         Aw Kong Koy" <infomap@tm.net.my>.
30/12/97 V0.97 Added a Cookie property to send cookies
11/01/98 V0.98 Added WSocket read-only property which enable to access the
         socket component used internally. For example to close it to abort
         a connection.
13/01/98 V0.99 Added MultiThreaaded property to tell the component that it is
         working in a thread and should take care of it.
15/01/98 V1.00 Completely revised internal working to make it work properly
         with winsock 2. The TimeOut property is gone.
         Changed OnAnswerLine event to OnHeaderData to be more consistent.
         Replaced AnswserLine property by readonly LastResponse property.
         Added OnRequestDone event. Added GetAsync, PostAsync, HeadAsync
         asynchronous, non-blocking methods. Added Abort procedure.
16/01/98 V1.01 Corrected a bug which let some data be lost when receiving
         (thanks to  Fulvio J. Castelli <fulvio@rocketship.com>)
         Added test for HTTP/1.1 response in header.
31/01/98 V1.02 Added an intermediate message posting for the OnRequestDone
         event. Thanks to Ed Hochman <ed@mbhsys.com> for his help.
         Added an intermediate PostMessage to set the component to ready state.
04/02/98 V1.03 Added some code to better handle DocName (truncating at the
         first question mark).
05/02/98 V1.04 Deferred login after a relocation, using WM_HTTP_LOGIN message.
         Added workarounf to support faulty webservers which sent only a single
         LF in header lines. Submitted by Alwin Hoogerdijk <alwin@lostboys.nl>
15/03/98 V1.05 Enlarge buffers from 2048 to 8192 bytes (not for D1)
01/04/98 V1.06 Adapted for BCB V3
13/04/98 V1.07 Made RcvdHeader property readonly and cleared the content at the
         start of a request.
         Protected Abort method from calling when component is ready.
         Ignore any exception triggered by CancelDnsLookup in Abort method.
14/04/98 V1.08 Corrected a relocation bug occuring with relative path
26/04/98 V1.09 Added OnLocationChange event
30/04/98 V1.10 Added ProxyUsername and ProxyPassword. Suggested by
         Myers, Mike <MikeMy@crt.com>.
26/05/98 V1.11 Corrected relocation problem when used with ASP webpages
09/07/98 V1.12 Adapted for Delphi 4
         Checked argument length in SendCommand
19/09/98 V1.13 Added support for HTML document without header
         Added OnSessionConnected event, httpConnected state and
         httpDnsLookupDone state.
         Corrected a problem with automatic relocation. The relocation
         message was included in data, resulting in wrong document data.
         Added two new events: OnRequestHeaderBegin and OnRequestHeaderEnd.
         They replace the OnHeaderBegin and OnHeaderEnd events that where
         called for both request header (to web server) and response
         header (from web server)
22/11/98 V1.14 Added a Location property than gives the new location in
         case of page relocation. Suggested by Jon Robertson <touri@pobox.com>
21/12/98 V1.15 Set ContentLength equal to -1 at start of command.
31/01/99 V1.16 Added HostName property
01/02/99 V1.17 Port was lost in DoRequestAsync when using a proxy.
         Thanks to David Wright <wrightd@gamespy.com> for his help.
         Report Dns lookup error and session connect error in OnrequestDOne
         event handler as suggested by Jack Olivera <jack@token.nl>.
14/03/99 V1.18 Added OnCookie event.
16/03/99 V1.19 Added Accept property.
               Added a default value to Agent property.
               Changed OnCookie event signature (not fully implemented yet !).
07/05/99 V1.20 Added code to support Content Ranges by Jon Robertson
               <touri@pobox.com>.
24/07/99 V1.21 Yet another change in relocation code.
Aug 20, 1999  V1.22 Changed conditional compilation so that default is same
              as latest compiler (currently Delphi 4, Bcb 4). Should be ok for
              Delphi 5. Added Sleep(0) in sync wait loop to reduce CPU usage.
              Added DnsResult property as suggested by Heedong Lim
              <hdlim@dcenlp.chungbuk.ac.kr>. This property is accessible from
              OnStateChange when state is httpDnsLookupDone.
              Triggered OnDocData after writing to the stream.
Sep 25, 1999  V1.23 Yet another change in relocation code when using proxy
              Francois Demers <fdemers@videotron.ca> found that some webserver
              do not insert a space after colon in header line. Corrected
              code to handle it correctly.
              Cleared ContentType before issuing request.
Oct 02, 1999  V1.24 added AcceptRanges property. Thanks to Werner Lehmann
              <wl@bwl.uni-kiel.de>
Oct 30, 1999  V1.25 change parameter in OnCommand event from const to var to
              allow changing header line, including deleting or adding before
              or after a given line sent by the component.
Nov 26, 1999  V1.26 Yet another relocation fix !
Jun 23, 2000  V1.27 Fixed a bug in ParseURL where hostname is followed by a '?'
              (that is no path but a query).
Jul 22, 2000  V1.28 Handle exception during DnsLookup from the login procedure.
              Suggested by Robert Penz <robert.penz@outertech.com>
Sep 17, 2000  V1.29 Eugene Mayevski <Mayevski@eldos.org> added support for
              NOFORMS.
Jun 18, 2001  V1.30 Use AllocateHWnd and DeallocateHWnd from wsocket.
              Renamed property WSocket to CtrlSocket (this require code change
              in user application too).
Jul 25, 2001  V1.31 Danny Heijl <Danny.Heijl@cevi.be> found that ISA proxy adds
              an extra space to the Content-length header so we need a trim
              to extract numeric value.
              Ran Margalit <ran@margalit.com> found some server sending
              empty document (Content-Length = 0) which crashed the component.
              Added a check for that case when header is finished.
              Andrew N.Silich" <silich@rambler.ru> found we need to handle
              handle relative path using "../" and "./" when relocating. Thanks
              for his code which was a good starting point.
Jul 28, 2001  V1.32 Sahat Bun <sahat@operamail.com> suggested to change POST to
              GET when a relocation occurs.
              Created InternalClear procedure as suggested by Frank Plagge
              <frank@plagge.net>.
              When relocation, clear FRcvdHeader. If port not specified, then
              use port 80. By Alexander O.Kazachkin <kao@inreco.ru>
Jul 30, 2001 V1.33 Corected a few glitches with Delphi 1
Aug 18, 2001 V1.34 Corrected a bug in relocation logic: when server send only a
             header, with no document at all, relocation was not occuring and
             OnHeaderEnd event was not triggered.
             Corrected a bug in document name when a CGI was invoked (a '?'
             found in the URL). Now, ignore everything after '?' which is CGI
             parameter.
Sep 09, 2001 V1.35 Beat Boegli <leeloo999@bluewin.ch> added LocalAddr property
             for multihomed hosts.
Sep 29, 2001 V1.36 Alexander Alexishin <sancho@han.kherson.ua> corrected
             ParseUrl to handle the case where http:// is not at start of url:
             'first.domain.com/cgi-bin/serv?url=http://second.domain.com'
             Yet another relocation code change.
Oct 28, 2001 V1.37 Corrected SocketSessionClosed which called
             LocationSessionClosed when it was not needed.
Nov 10, 2001 V1.38 Fixed a bug where component was trying to connect to proxy
             using default port instead on specified port after a relocation.
             Corrected a bug when relocating to a relative path. Current path
             was not taken into account !
Mar 06, 2002 V1.39 Fixed a bug in relocation when content-length was 0: no
             relocation occured ! (Just check for relocation before checking
             content length empty).
Mar 12, 2002 V1.40 Added UrlEncode and UrlDecode utility functions.
Mar 30, 2002 V1.41 Export a few utility functions: IsDigit, IsXDigit, XDigit,
             htoin and htoi2.
Apr 14, 2002 V1.42 Paolo S. Asioli <paolo.asioli@libero.it> found a bug in
             relocation code where new user/pass are specified.
             On relocation, change DocName according to the relocation.
             When DocName has no extension and ContentType is text/html the
             add extension .htm (could be expanded do other content type)
Apr 20, 2002 V1.43 Added Socks code from Eugene Mayevski <mayevski@eldos.org>
Apr 21, 2002 V1.44 In LocationSessionClosed, clear status variables from
             previous operation.
Sep 06, 2002 V1.45 Made a few more methods virtual.
Sep 10, 2002 V1.46 Added AcceptLanguage property.
Sep 11, 2002 V1.47 Wilfried Mestdagh <wilfried@mestdagh.biz> added
             OnBeforeHeaderSend event to help add/remove/change header lines.
             He also corrected SocketSessionClosed to report error code.
Feb 08, 2003 V1.48 Implemented more HTTP/1.1 features notably TCP session
             persistance.
Feb 22, 2003 V1.49 Corrected a bug related to document length computation.
             Thanks to Dav999 <transmaster@ifrance.com> who found a
             reproductible case with perso.wanadoo.fr webserver.
Apr 27, 2003 V1.50 OnLocationChange was not called when a relocation occured
             and server handle HTTP/1.1 and new location on same server.
May 01, 2003 V1.51 Location and URL properties where incorrect after relocation
             to same HTTP/1.1 server.
             Change POST to GET after relocation to same HTTP/1.1 server.
May 09, 2003 V1.52 Implemented PUT method
May 31, 2003 V1.53 Corrected a problem with relocation when a proxy was used
             and a relative path was given.
Aug 21, 2003 V1.54 Removed HTTPCliDeallocateHWnd virtual attribute for BCB
             because of a bug in BCB preventing linking any derived
             component with a HWND argument in a virtual method.
             With help from Steven S. Showers and Stanislav Korotky.
Nov 26, 2003 V1.55 Implemented OnDataPush event for server push handling.
             Added OnSessionClosed event.
             Corrected ParseUrl to correctly handle protocol specified in
             uppercase. Thanks to "Nu Conteaza" <osfp@personal.ro>.
             Implemented OnDataPush2 event. Not the same as OnDataPush:
               OnDataPush: Need to call Receive to get data
               OnDataPush2: Data already received and delivered in LastResponse
Dec 28, 2003 V1.56 Implemented TransferEncoding = chunked
             Moved code for relocation after document receive so that even in
             case of a relocation, any available document is preserved.
             Thanks to Steve Endicott <Endi@pacbell.net> for his help.
Jan 09, 2004 V1.57 Fixed a relocation not done when end of document is in the
             same data packet as the last header line. With help of S. Endicott.
             Steve Endicott <Endi@pacbell.net> implemented "Connection: close"
             header line.
Jan 12, 2004 V1.58 "Ted T�raasen" <Ted@extreme.no> added proprety
             FollowRelocation (default to TRUE) to have the component follow
             relocation or just ignore them.
Jan 15, 2004 V1.59 Set FRcvdCount to zero in StartRelocation (S. Endicott).
             Started to implement NTLM authentication. Doesn't work yet !
Jan 26, 2004 V1.60 Reordered uses clause for FPC compatibility.
Feb 16, 2004 V1.61 Fixed GetHeaderLineNext to start relocation at the right
             moment. See annotation "16/02/2004".
Mar 12, 2004 Fixed GetHeaderLineNext to check for StatusCode < 200, 204 and
             304 in order to not wait for body.
             Thanks to Csonka Tibor <bee@rawbite.ro> for finding a test case.
Jul 12, 2004 Just this warning: The component now doesn't consider 401 status
             as a fatal error (no exception is triggered). This required a
             change in the application code if it was using the exception that
             is no more triggered for status 401.
Jul 18, 2004 V1.63 Use CompareText to check for http string is relocation
             header. Thanks to Roger Tinembart <tinembart@brain.ch>
Jul 23, 2004 V1.64 Fixed a line too long exception when requesting HEAD or URL
             http://de.news.yahoo.com:80/. The server was sending a document
             even after we requested just the header. The fix make the
             component ignore data and abort the connection. This is really an
             error at server side !
Aug 08, 2004 V1.65 Moved utility function related to URL handling into IcsUrl
             unit for easy reuse outside of the component.
Aug 20, 2004 V1.66 Use MsgWaitForMultipleObjects in DoRequestSync to avoid
             consumming 100% CPU while waiting.
Sep 04, 2004 V1.67 Csonka Tibor <bee@rawbite.ro> worked a lot on my NTLM code,
             fixing it and making it work properly.
             I removed NTLM specific usercode and password properties to use
             FUsername and FPassword which are extracted from the URL.
             Define symbol UseNTLMAuthentication for Delphi 5 and up.
Sep 13, 2004 V1.68 Added option httpoNoNTLMAuth by Csonka Tibor
             Fixed TriggerRequestDone for NTLM authentication
             Moved NTLM code out of DoBeforeConnect which was intended for
             socket setup and not for protocol handling.
Oct 02, 2004 V1.69 Removed second copy of IntToStrDef.
Oct 06, 2004 V1.70 Miha Remec fixed THttpCli.GetHeaderLineNext to add
             status check for 301 and 302 values.
Oct 15, 2004 V1.71 Lotauro.Maurizio@dnet.it enhanced basic and NTLM
             authentifications methods. Event OnNTLMAuthStep has been
             removed. Now basic authentication is not automatically sent with
             a request. It is only sent when the server request it by replying
             with a 401 or 407 response. Sending basic authentication in the
             first request was a kind of security threat for NTLM:
             usercode/password is sent unencrypted while NTLM is made to send
             it encrypted (DES). This has the side effect of requiring two
             request where one was needed. This could be a problem when posting
             data: data has to be posted twice ! This is transparent to the user
             except for performance :-( A future enhancement could be a new
             option to always send basic authentication.
Oct 30, 2004 V1.72 Made SendRequest virtual.
Nov 07, 2004 V1.73 Added CleanupRcvdStream. Lotauro.Maurizio@dnet.it found that
             document must be cleaned if received in intermediate authentication
             steps.
Nov 09, 2004 V1.74 Cleared FDoAuthor from InternalClear. Thanks Maurizio.
Nov 11, 2004 V1.75 Added CleanupRcvdStream when starting relocation.
             Thanks Maurizio.
             Removed second TriggerHeaderEnd in GetHeaderLineNext.
             Thanks Ronny Karl for finding this one.
Nov 20, 2004 V1.76 Angus Robertson found a problem with SendStream because of
             authentication (post restarted because authentication need to be
             done).
             Maurizio fixed the issue above an a fix others:
             - added a CleanupSendStream procedure, and added a call to it in
               every place where the CleanupRcvdStream is called.
             - changed the Content-Length calculation: if the position of the
               stream is not 0 then the length was wrong
             - changed the the test in DoRequestAsync: if the position of the
               stream is at the end then it will send nothing
Nov 22, 2004 V1.77 Only a single error code for httperrInvalidAuthState.
Dec 14, 2004 V1.78 Excluded code 407 and added code 400 in DoRequestSync
Dec 19, 2004 V1.79 Revised CleanupRcvdStream to make it compatible with D1.
Dec 22, 2004 V1.80 Changed SocketDataAvailable so that header lines that are
             too long to fit into the receive buffer (8K) are simply truncated
             instead of triggering an exception.
Jan 05, 2005 V1.81 Maurizio Lotauro <Lotauro.Maurizio@dnet.it> optimized NTLM
             authentication by not sending content in the first step.
Jan 29, 2005 V1.82 Fixed socks properties propagation to control socket.
Feb 05, 2005 V1.83 Fixed GetHeaderLineNext in the case Abort is called from
             OnHeaderEnd event (Bug reported by Csonka Tibor).
             Fixed relocation to https destination when USE_SSL is not
             defined. It is handled as a non implemented protocol.
Mar 19, 2005 V1.84 Changed CleanupRcvdStream to check for COMPILER3_UP instead
             of checking DELPHI3_UP (BCB compatibility issue).
             Changed StrToIntDef to check for COMPILER5_UP instead of
             DELPHI5_UP (BCB compatibility issue). Thanks to Albert Wiersch.
Mar 21, 2005 V1.85 Added port in "host:" header line as suggested by Sulimov
             Valery <99valera99@rambler.ru>.
             In DoRequestAsync, allow to continue even with no data to be sent.
Apr 14, 2005 V1.86 Fixed PrepareBasicAuth to ignore charcase when checking for
             'basic' keyword in header line. Thanks to abloms@yahoo.com for
             finding this bug which affected use thru iPlanet Web Proxy Server.
Apr 16, 2005 V1.87 Applyed the fix above to PrepareNTLMAuth (two places),
             StartAuthNTLM and StartProxyAuthNTLM.
May 26, 2005 V1.88 Fixed DoRequestAsync to set http as default protocol.
Aug 15, 2005 V1.89 Implemented bandwidth control for download (Get).
Oct 31, 2005 V1.89a rework of authentication handling to fix a problem that could
               happen when both proxy and remote server needed an authentication
               causing an infinite loop, by Maurizio Lotauro
             - removed the TXXXAuthType type and the variables of that types
             - properties Username and Password will no more replaced by the
               credential contained in the URL. Two new variables are introduced
               FCurrUsername and FCurrPassword. These will contain the credential
               in the URL (if specified), otherwise the content of the property.
            - same logic for Connection and ProxyConnection (introduced
              FCurrConnection and FCurrProxyConnection)
Nov 19, 2005 V1.89b supports SSL v5 by Arno Garrels
Nov 27, 2005 V1.90 implemented redirection limiting to avoid continuous
             looping to same URL, by Angus Robertson, Magenta Systems
             test example is http://www.callserve.com/ that keeps looping
             Implemented ContentEncoding (can be disabled with define
             UseContentCoding), mostly done in new HttpContCod.pas,
             add HttpCCodzlib to your project for GZIP compression support,
             and set httpoEnableContentCoding in Options to enable it
             by Maurizio Lotauro <Lotauro.Maurizio@dnet.it>
Dec 20, 2005 V1.91 new configurable DebugOptions to replace IFDEF DEBUG_OUTPUT,
             see wsocket for more information
Apr 10, 2006 V6.00.1 Added LowerCase for FTransferEncoding? Thanks to Fastream.
Dec 10, 2006 V6.00.2 Jack <jlist9@gmail.com> fixed BandwidthTimerTimer to clear
             the count.
Mar 17, 2007 V6.00.3 Introduced THttpBigInt to support documents longer
             than 2GB.
Mar 19, 2007 V6.00.3 A.Garrels fixed a memory leak of FSendBuffer and
             FReceiveBuffer. Check for negative value of FReceiveLen in
             SocketDataAvailable.
May 27, 2008 V6.00.4 A.Garrels Workaround in GetHeaderLineNext. Ignore body data
             sent in the HEAD response by buggy servers.
Jun 25, 2008 V6.00.5 A. Garrels SSL code merged.
Jul 17, 2008 V6.00.6 A. Garrels made a few changes to prepare code for Unicode,
             added OverbyteIcsUtils to the uses clause, optimized
             MoveTBytesToString a bit, removed some stuff for older compilers,
             removed typedef of TBytes, now uses TBytes of OverbyteIcsTypes.pas.
Sep 28, 2008 V6.00.7 Maurizio Lotauro fixed a bug with premature received
             401/407 responses while data was still being sent with POST and PUT
             requests. A. Garrels small fix in SendCommand().
Sep 29, 2008 V6.00.8 A. Garrels added OverbyteIcsUtils to the uses clause
             for all compilers.
Dec 06, 2008 V7.00.9 A. Garrels fixed function EncodeStr and EncodeLine.
Jan 11, 2009 V7.01 A. Garrels fixed a bug with proxies which do not
             send a Content-Length header in non-persistent connections by
             simply always setting FReceiveLen to zero in SocketSessionClosed.
Jan 11, 2009 V7.02 A. Garrels - Added Digest Access Authentication.
             In order to disable this feature entirely undefine directive
             UseDigestAuthentication below.
             Added new event OnBeforeAuth that can be used to skip internal
             authorization by setting argument Allow to FALSE.
             ** Also cleaned up the source code a bit, thus a comparison
             with previous version, unfortunately won't be fun. **
Jan 12, 2009 V7.02a Arno added two missing lines for digest auth to the SSL code.
Jan 22, 2009 V7.02b Sorry guys! Re-added property OnBeforeHeaderSend again
             which I (Arno) removed in V7.02 accidently :(
Jan 22, 2009 V7.02c Arno - Conditional define UseDigestAuthentication was not
             set properly in THttpCli.StateChange.
Apr 25, 2009 V7.03 Steve Endicott fixed a relocation bug with HTTPS.
Sep 17, 2009 V7.04 Arno added property Timeout, works only with synchronous
             methods!
Dec 02, 2009 V7.05 Bjornar found a HTTPS POST bug with proxy basic
             authentication that added two Content-Length header lines.
Feb 15, 2010 V7.06 Yuri Semenov fixed a bug with content coding and chunked
             transfer encoding.
Feb 25, 2010 V7.07 Fix by Bj�rnar Nielsen: TSslHttpCli didn't work when used
             against Websense-Content_Gateway (http://www.websense.com) and
             some others. The problem was that this (and some other proxies too)
             answer 200 OK to notify client that connection to remote server
             is established. Usually proxies use 200 OK and an error text when
             something is wrong. In that case Content-Length is not 0.
May 24, 2010 V7.08 Angus ensure Ready when relocations exceed maximum to avoid timeout
Oct 10, 2010 V7.09 Arno - MessagePump changes/fixes.
Nov 05, 2010 V7.10 Arno fixed ERangeErrors after Abort.
Nov 08, 2010 V7.11 Arno improved final exception handling, more details
             in OverbyteIcsWndControl.pas (V1.14 comments).
Nov 22, 2010 V7.12 Arno made CheckDelaySetReady virtual.
Feb 4,  2011 V7.13 Angus - if conditional BUILTIN_THROTTLE is defined the
             bandwidth control uses TWSocket's built-in throttle code rather
             than THttpCli's.
Feb 18, 2011 V7.14 Arno - Proxy authentication with relocations (hopefully) fixed.
             SSL not tested yet. If it still doesn't work it's probably a buggy
             proxy server i.e. 3Proxy. Parse NTLM user codes into domain and
             username parts and pass them to NtlmGetMessage3 in method
             GetNTLMMessage3.
Feb 19, 2011 V7.15 Arno - Proxy authentication with relocations still did not
             work properly :( It's not perfect but works better now:
             Reset only NTLM AuthState in LocationSessionClosed and do not call
             SetReady while FLocationFlag is set, also call StartRelocation in
             GetHeaderLineNext if there's no body and the connection is not
             expected to close, also the relocation counter was incremented
             twice per relocation when the connection closed.
             Fix in Digest authentication.
Apr 15, 2011 V7.16 Arno prepared for 64-bit.
Jul 22, 2011 V7.17 Arno - OEM NTLM changes.
Sep 11, 2011 V7.18 Arno fixed a bug in chunked decoding, sponsored by Fastream
             (www.fastream.com).
Oct 6, 2011  V7.19 ensure content decompression triggered at end of document,
             failed if Content-Length missing, thanks to Yuri Semenov for the fix
Oct 09, 2011 V7.20 Arno - Clear FResponseVer after relocations when the connection
             was closed. This ensures that ProxyConnection keep-alive is set on
             proxy-reconnects after relocation with HTTPS as well.
             Made a change in GetHeaderLineNext to fix a bug with 401 and 407
             responses when no content-length header was present (body was parsed
             as header, thanks to Fastream for reporting).
Nov 20, 2011 V7.21 Jean DELAGOUTTE - Do not clear FContentRangeBegin and
             FContentRangeEnd with method CONNECT.
Jan 20, 2012 V7.22 RTT changed GetHeaderLineNext to support relocation URLs
             starting with "//".
Jan 23, 2012 V7.23 Arno added httperrNoStatusCode, passed to OnRequestDone and
             raised in sync mode if connection closed prematurely. Always raise
             EHttpException with the internal httperror code rather than the
             HTTP status code if FRequestDoneError is set, this changed
             EHttpException's ErrorCode property value of abort and timeout
             exceptions.
Feb 15, 2012 V7.24 Tobias Rapp added methods Del and DelAsync (HTTP method DELETE).
Feb 17, 2012 V7.25 Arno added NTLMv2 and NTLMv2 session security (basics),
             read comment "HowTo NTLMv2" in OverbyteIcsNtlmMsgs.pas.
May 2012 - V8.00 - Arno added FireMonkey cross platform support with POSIX/MacOS
                   also IPv6 support, include files now in sub-directory
Dec 15, 2012 V8.01 Arno fixed missing port number in both Host header and property
             Location.
Mar 18, 2013 V8.02 - Angus added LocalAddr6 for IPv6
             Note: SocketFamily must be set to sfAny, sfIPv6 or sfAnyIPv6 to
                   allow a host name to resolve to an IPv6 address.
Apr 22, 2013 V8.03 Arno fixed an AV in THttpCli that raised when Abort
             was called, i.e. from OnDocData event handler and SSL enabled.
Jul 11, 2013 V8.04 - Angus changed default Agent to 'Mozilla/4.0' removing
                        (compatible; ICS) which upset some servers
Oct 10, 2013 V8.05 - Arno fixed a relocation bug with URL "https://yahoo.com" by
             removing port "443" from the Host-header, otherwise relocation
             header returned by the server had that port appended as well even
             though the new location was simple HTTP.
Apr 19, 2014 V8.06 Angus added PATCH method, thanks to RTT <pdfe@sapo.pt>
Jun  4, 2014 V8.07 Angus fixed POST 307 and 308 now redirects with POST method,
                   thanks to RTT <pdfe@sapo.pt>
             Note POST redirection is poorly and confusingly documented in the RFCs,
               a 307 POST should ideally be confirmed by the user, somehow...
Jul 14, 2014 V8.08 Angus try and match how Chrome and Firefox handle POST relocation,
                   thanks to RTT <pdfe@sapo.pt> again
Jul 16, 2014 V8.09 Angus added new methods: OPTIONS and TRACE
                   published RequestType for events
Jul 18, 2014 V8.10 Angus applied V8.08 change to another function
Jun 01, 2015 V8.11 Angus update SslServerName for SSL SNI support allowing server to
                     select correct SSL context and certificate
Oct 19, 2015 V8.12 Angus allow better SSL Handshake error reporting
Feb 22, 2016 V8.13 Angus check statuscode with StrToIntDef to avoid errors
                   ensure headers added in event are logged
                   Angus moved RFC1123_Date and RFC1123_StrToDate to Utils
Nov 04, 2016 V8.37 V8.10 POST relocation fix failed 302 because status had been cleared
                   Don't set blank SocksLevel
                   Don't suppress socket exceptions unless we handle them with OnSocketError,
                      note this means more exceptions may need to be handled
                   Added extended exception information, set FSocketErrs = wsErrFriendly for
                      some more friendly messages (without error numbers)
May 18, 2017 V8.48 Fixed SslServerName for correct host target name with SSL proxies
Sep 17, 2017 V8.50 Replaced four TBytes functions with versions in OverbyteIcsUtils
Dec 7,  2017 V8.51 Fixed SOCKS4A/5 skip DNSLookup since hostname is passed to SOCKS server
                      so it can resolve DNS instead, thanks to Colin Wall for fixing this.
                   Socks authstate event now works
                   Report sensible proxy and socks ReasonPhrase
Feb 16, 2018 V8.52 Added ExtraHeaders property to simplify adding extra headers to
                     a request (previously done using onBeforeHeaderSend event)
May 21, 2018 V8.54 Added httpAuthBearer and httpAuthToken, and AuthBearerToken for OAuth1/2
                   Connected now available as a property
                   Added ResponseNoException property to suppress error exceptions for
                     sync requests, ie most 400 and 500 status codes (eases debugging).
Jun 18, 2018 V8.55 ReasonPhrase for abort may return SSL handshake error.
                   Minor clean-up, more relocation debugging
Sep 5, 2018  V8.57 Added OnSelectDns event to allow application to change DnsResult to
                       one of the several offered, round robin or IPv4/IPv6
Mar 15, 2019 V8.60 Added AddrResolvedStr read only property which is the IPv4/IPv6
                      address to which the client is trying to connect.
                   Added IP address and port to 404 Connect error.
                   Added round robin DNS lookup if DNSLookup returns multiple
                     IP addresses so they are used in turn after a failure
                     when the component is called repeatedly.
                   Only follow relocation for 3xx response codes, not 201 Created,
                     but keep Location for 201 which is often response to a POST.
Apr 09, 2019 V8.61 OAS : Improved NTLM authentication by adding Single Sign On with
                     NTLM Session on Windows Domain to get credentials without needing
                     them specified here.
                   Added TriggerRequestDone2 to correct overriding RequestDone event.
                   Added TriggerCommand, TriggerHeaderData, TriggerLocationChange
                     and TransferSslHandshakeDone to allow overriding those events.
                   Added more header response properties: RespDateDT,
                     RespLastModDT, RespExpires, RespCacheControl.
                   NoCache now sends Cache-Control: no-cache for HTTP/1.1
Jun 25, 2019 V8.62 Added httpAuthJWT using AuthBearerToken for Json Web Token
                     authentication.
                   Added ProxyURL property which combines four proxy properties
                     as a URL for simplicity, ie http://[user[:password]@]host:port
                   Added AlpnProtocols property which is sent when an SSL connection
                     starts and GetAlpnProtocol which returns which the server
                     supports.
Mar 10, 2020 V8.64 Added support for International Domain Names for Applications (IDNA),
                     i.e. using accents and unicode characters in domain names.
                   Host: header now has A-Label (Punycode ASCII) domain name.
                   Proxy URL host is converted to A-Label.
                   Location property returms a Unicode URL.
                   PunyCodeHost read only returns A-Label for first DNSLookup.
Dec 09, 2020 V8.65 Added httpAuthOAuth using AuthBearerToken for OAuth1A authentication.
                   Don't clear PunyCodeHost for each request, only login.
                   Increased onDataAvailable receive BUF_SIZE from 8192 to 66536.
                   Only define UseNTLMAuthentication for Windows.
                   Renamed Ics.Posix.Messages.pas to Ics.Posix.PXMessages.pas.
Mar 16, 2021 V8.66 AddrResolvedStr is now still available after connection closes.
                   When using an HTTPS proxy with the CONNECT command don't send host
                     and port which some servers are unable to handle, probably broken
                     with V8.84.
Jul 12, 2021 V8.67 Renamed FBodyLineCount to FBodyStartedFlag since count never used,
                     fixes a problem with very long streams being received.
                   Fixed a relocation problem where the Location: header included
                     a path with a space, encode it.
                   Fixed another relocation problem where HEAD sometimes stalled.
                   Replaced Stream.Seek with Stream.Position.
                   Remove # fragment or anchor from URL in relocation, only used by
                     browsers and not by servers.
Dec 20, 2021 V8.68 Made RequestDoneError available as property so it can be accessed
                     after Sync requests, added RequestDoneErrorStr property that
                     returns a literal error.
                   Try to provide better RequestDoneError than simple abort, added
                     httperrOutOfMemory and httperrBgException which happen while
                     receiving and processing data in the OnDocData event and
                     httperrSslHandShake.
                   Improved AbortComponent so ReasonPhrase now reports exception
                     that caused it, such as out of memory which previously needed
                     a BgException event handler.
                   Keep Etag response header as ResponseEtag.
                   Added ContentIfRange request header only sent if content range
                     specified, with an RFC1123 date or Etag.
                   Added ReqIfMatch and ReqIfNoneMatch request headers sent with
                     one or more quoted Etag values.
May 19, 2022 V8.69 Added RequestAsync and RequestSync which start a specified
                     request by parameter, useful to repeat the last request
                     from an event (such as should be trust the cert and repeat).
                   When using a proxy, make sure Path is not blank which will
                     break proxies, change to / as for non-proxy requests.
                   GetRequestDoneErrorStr handles wsocket errors.
                   NTLM authentication got broken in V8.61.
                   Added new THttpAuthType httpAuthDigest2 for Digest with SHA-256
                     algorithm instead of MD5 used by httpAuthDigest, only with USE_SSL.
                   Added new property WWWAuthInfos array filled after 401/407 failure
                     by parsing AuthorizationRequest headers for AuthType and Realm
                     that may be presented to select an authentication option,
                     get login and repeat request.
                   Simplified PreparexxAuth functions by using WWWAuthInfos array
                     instead of looping through AuthorizationRequest headers.
                   Remove # fragment anchor from URL unless Option httpoAllowAnchor
                     is set.
Oct 20, 2022 V8.70 OverbyteIcsHttpCCodZLib used for content decoding now allows use of
                     System.ZLib which means it also works on Posix, no changes here.
Jun 25, 2023 V8.71 Changed property LmCompatLevel from public to published so it's
                     more obvious, suggested set to 1.
                   Added OnSyncRequestWait event called while waiting for sync operations
                     to finish, so it can be stopped before timeout expires.
                   Added TriggerHeaderFieldData virtual method to allow request header
                     modification and logging before processing, see OverbyteIcsWebSocketCli.
                   Added GetProtocolPort, IsSSLProtocol, IsKnownProtocol and
                     IsKnownProtocolURL methods to centralise checking of URLs and
                     allowing override in descendent components.
                   In create, synchronize FSocksLevel with default FCtrlSocket.SocksLevel.
                   Improved EHttpException messages with more detail.
                   Above fixes thanks to Jaroslav Kul�sek.
                   Some servers allow the GET and DELETE requests to have content similarly
                     to PUT so allow this if new Options httpoGetContent is specified but
                     beware to set SendStream to nil if no content is intended, thanks
                     to H.Stadtmuller for this change.
                   Try to prevent the header and content from being sent as separate TCP
                     packets which may confuse some middleware, thanks to H.Stadtmul.
                   Always check if SendStream exists before accessing it, thanks to H.Stadtmul.
                   Using Int64 ticks.
                   Removed very old UseBandwidthControl conditional code, only
                     supporting BUILTIN_THROTTLE now.
                   Added check that OpenSSL is loaded before request starts.
Aug 08, 2023 V9.0  Updated version to major release 9.



To convert the received HTML stream to a unicode string with the correct codepage,
use this function in OverbyteIcsCharsetUtils, it's not used directly by this unit
to avoid linking in various charset tables applications may not need. The last
argumment determines whether entities like &pound; and &#9741; are converted to
characters:

UnicodeStr := IcsHtmlToStr(RcvdStream, ContentType, true);

 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{$IFNDEF ICS_INCLUDE_MODE}
unit PasAI.ICS9.OverbyteIcsHttpProt;
{$ENDIF}

interface

{$I Include\PasAI.ICS9.OverbyteIcsDefs.inc}
{$IFNDEF COMPILER7_UP}
  {$MESSAGE FATAL 'Sorry, we do not want to support ancient compilers any longer'};
{$ENDIF}
{$IFDEF COMPILER14_UP}
  {$IFDEF NO_EXTENDED_RTTI}
    {$RTTI EXPLICIT METHODS([]) FIELDS([]) PROPERTIES([])}
  {$ENDIF}
{$ENDIF}

{$WARN SYMBOL_PLATFORM   OFF}
{$WARN SYMBOL_LIBRARY    OFF}
{$WARN SYMBOL_DEPRECATED OFF}

{$B-}             { Enable partial boolean evaluation   }
{$T-}             { Untyped pointers                    }
{$X+}             { Enable extended syntax              }
{$H+}             { Use long strings                    }
{$J+}             { Allow typed constant to be modified }
{$IFDEF BCB}
    {$ObjExportAll On}
{$ENDIF}
{$IFNDEF NO_ADVANCED_HTTP_CLIENT_FEATURES}
    {$IFDEF MSWINDOWS}                    { V8.65 only for Windows }
        {$DEFINE UseNTLMAuthentication}
    {$ENDIF}
    {$DEFINE UseDigestAuthentication}
    {$DEFINE UseContentCoding}
{$ENDIF}

uses
{$IFDEF MSWINDOWS}
    {$IFDEF RTL_NAMESPACES}Winapi.Messages{$ELSE}Messages{$ENDIF},
    {$IFDEF RTL_NAMESPACES}Winapi.Windows{$ELSE}Windows{$ENDIF},
    PasAI.ICS9.OverbyteIcsWinsock,
{$ENDIF}
{$IFDEF POSIX}
    PasAI.ICS9.Ics.Posix.WinTypes,
    PasAI.ICS9.Ics.Posix.PXMessages,
{$ENDIF}
    {$IFDEF RTL_NAMESPACES}System.SysUtils{$ELSE}SysUtils{$ENDIF},
    {$IFDEF RTL_NAMESPACES}System.Classes{$ELSE}Classes{$ENDIF},
    {$IFDEF RTL_NAMESPACES}System.TypInfo{$ELSE}TypInfo{$ENDIF},    { V8.71 JK }
{$IFNDEF NOFORMS}
  {$IFDEF FMX}
    FMX.Forms,
  {$ELSE}
    {$IFDEF RTL_NAMESPACES}Vcl.Forms{$ELSE}Forms{$ENDIF},
  {$ENDIF}
{$ENDIF}
{ You must define USE_SSL so that SSL code is included in the component.   }
{ Either in OverbyteIcsDefs.inc or in the project/package options.         }
{$IFDEF USE_SSL}
    PasAI.ICS9.OverbyteIcsSSLEAY, PasAI.ICS9.OverbyteIcsLIBEAY,
{$ENDIF}
{$IFDEF FMX}
    PasAI.ICS9.Ics.Fmx.OverbyteIcsWndControl,
    PasAI.ICS9.Ics.Fmx.OverbyteIcsWSocket,
{$ELSE}
    PasAI.ICS9.OverbyteIcsWndControl,
    PasAI.ICS9.OverbyteIcsWSocket,
{$ENDIF FMX}
{$IFDEF UseNTLMAuthentication}
    PasAI.ICS9.OverbyteIcsMimeUtils,
    PasAI.ICS9.OverbyteIcsNtlmMsgs,
    PasAI.ICS9.OverbyteIcsSspi,
    PasAI.ICS9.OverbyteIcsNtlmSsp,
{$ENDIF}
{$IFDEF UseDigestAuthentication}
    PasAI.ICS9.OverbyteIcsDigestAuth,
{$ENDIF}
    PasAI.ICS9.OverbyteIcsUrl,
{$IFDEF UseContentCoding}
    PasAI.ICS9.OverbyteIcsHttpContCod,
{$ENDIF}
{$IFNDEF NO_DEBUG_LOG}
    PasAI.ICS9.OverbyteIcsLogger,
{$ENDIF}
    PasAI.ICS9.OverbyteIcsTypes,
    PasAI.ICS9.OverbyteIcsUtils,
    PasAI.ICS9.OverbyteIcsTicks64;    { V8.71 }

const
    HttpCliVersion       = 900;
    CopyRight : String   = ' THttpCli (c) 1997-2023 F. Piette V9.0 ';
    DefaultProxyPort     = '80';
    { EHttpException error code }
    httperrBase                     = {$IFDEF MSWINDOWS} 1 {$ELSE} 1001 {$ENDIF}; { V7.23 }
    httperrNoError                  = 0;
    httperrBusy                     = httperrBase;
    httperrNoData                   = httperrBusy + 1;
    httperrAborted                  = httperrNoData + 1;
    httperrOverflow                 = httperrAborted + 1;
    httperrVersion                  = httperrOverflow + 1;
    httperrInvalidAuthState         = httperrVersion + 1;
    httperrSslHandShake             = httperrInvalidAuthState + 1;
    httperrCustomTimeOut            = httperrSslHandShake + 1;
    httperrNoStatusCode             = httperrCustomTimeOut + 1;
    httperrOutOfMemory              = httperrNoStatusCode + 1;        { V8.68 }
    httperrBgException              = httperrOutOfMemory + 1;         { V8.68 }
    { Change next as well if new EHttpException error codes are added }
    httperrMax                      = httperrBgException;

type
    THttpBigInt = Int64;

    EHttpException = class(Exception)
    private
        FErrorCode: Word;
    public
        property ErrorCode : Word read FErrorCode write FErrorCode;
        constructor Create(const Msg : String; ErrCode : Word);
    end;

    THttpEncoding    = (encUUEncode, encBase64, encMime);
    THttpRequest     = (httpABORT, httpGET, httpPOST, httpPUT,
                        httpHEAD, httpDELETE, httpCLOSE, httpPATCH,
                        httpOPTIONS, httpTRACE);  { V8.09 }
    THttpState       = (httpReady,         httpNotConnected, httpConnected,
                        httpDnsLookup,     httpDnsLookupDone,
                        httpWaitingHeader, httpWaitingBody,  httpBodyReceived,
                        httpWaitingProxyConnect,
                        httpClosing,       httpAborting);
    THttpChunkState  = (httpChunkGetSize, httpChunkGetExt, httpChunkGetData,
                        httpChunkSkipDataEnd, httpChunkDone);
{$IFDEF UseNTLMAuthentication}
    THttpNTLMState   = (ntlmNone, ntlmMsg1, ntlmMsg2, ntlmMsg3, ntlmDone);
{$ENDIF}
{$IFDEF UseDigestAuthentication}
    TAuthDigestInfo  = TAuthDigestResponseInfo;
    THttpDigestState = (digestNone, digestMsg1, digestDone);
{$ENDIF}
    THttpBasicState  = (basicNone, basicMsg1, basicDone);
    THttpAuthType    = (httpAuthNone, httpAuthBasic, httpAuthNtlm,
                        httpAuthDigest, httpAuthBearer, httpAuthToken,   { V8.54 }
                        httpAuthJWT, httpAuthOAuth, httpAuthDigest2);  { V8.62, V8.65, V8.69 }
    THttpBeforeAuthEvent   = procedure(Sender  : TObject;
                                 AuthType      : THttpAuthType;
                                 ProxyAuth     : Boolean;
                                 const AuthHdr : String;
                                 var Allow     : Boolean) of object;
    TOnCommand       = procedure (Sender : TObject;
                                  var S: String) of object;
    TDocDataEvent    = procedure (Sender : TObject;
                                  Buffer : Pointer;
                                  Len    : Integer) of object;
    TCookieRcvdEvent = procedure (Sender       : TObject;
                                  const Data   : String;
                                  var   Accept : Boolean) of object;
    THttpRequestDone = procedure (Sender  : TObject;
                                  RqType  : THttpRequest;
                                  ErrCode : Word) of object;
    TBeforeHeaderSendEvent = procedure (Sender       : TObject;
                                        const Method : String;
                                        Headers      : TStrings) of object;
    THttpCliOption = (httpoNoBasicAuth, httpoNoNTLMAuth, httpoBandwidthControl,
                  {$IFDEF UseContentCoding}
                      httpoEnableContentCoding, httpoUseQuality,
                  {$ENDIF}
                      httpoNoDigestAuth, httpoAllowAnchor,  { V8.69 allow # fragment anchor in URL }
                      httpoGetContent);                     { V8.71 allow content in GET and DELETE, like PUT }
    THttpCliOptions = set of THttpCliOption;
    TLocationChangeExceeded = procedure (Sender              : TObject;
                                  const RelocationCount      : Integer;
                                  var   AllowMoreRelocations : Boolean) of object;  {  V1.90 }
    TSelectDnsEvent = procedure(Sender : TObject;
                                  DnsList     : TStrings;
                                  var NewDns  : String) of object;      { V8.57 }
    TWWWAuthInfo = record
       AuthType: THttpAuthType;
       Realm: String;
       CharSet: String;
       Uri: String;
       Header: String;
    end;                                                                { V8.69 parsed from WWW-Authenticate headers }
    TWWWAuthInfos = Array of TWWWAuthInfo;                              { V8.69 }
    THttpAuthTypes = Set of THttpAuthType;                              { V8.69 }

const
    HttpCliAuthNames: array [THttpAuthType] of PChar = (              { V8.69 }
        'None','Basic (Clear)','NTLM Domain','Digest MD5','Bearer Token','XAuth Token',
        'Json Web Token','OAuth Bearer','Digest SHA-256');

type
    TOnSyncRequestWaitEvent = procedure(Sender: TObject; var AbortRequired: Boolean; var AbortMsg: String) of object;  { V8.71 JK }
    THttpCli = class(TIcsWndControl)
    protected
        FMsg_WM_HTTP_REQUEST_DONE : UINT;
        FMsg_WM_HTTP_SET_READY    : UINT;
        FMsg_WM_HTTP_LOGIN        : UINT;
        FCtrlSocket           : TWSocket;
        FSocketFamily         : TSocketFamily;
        FState                : THttpState;
        FLocalAddr            : String;
        FLocalAddr6           : String; { V8.02 IPv6 address for local interface to use }
        FHostName             : String;
        FTargetHost           : String;
        FTargetPort           : String;
        FPort                 : String;
        FProtocol             : String;
        FProxy                : String;
        FProxyPort            : String;
        FUsername             : String;
        FPassword             : String;
        FCurrUsername         : String;
        FCurrPassword         : String;
        FProxyUsername        : String;
        FProxyPassword        : String;
        FProxyURL             : String;     { V8.62 combines Proxy/PrexyPort/ProxyUserName/proxyPassword as URL }
        FProxyConnected       : Boolean;
        FLocation             : String;
        FCurrentHost          : String;
        FCurrentPort          : String;
        FCurrentProtocol      : String;
        FConnected            : Boolean;
        FDnsResult            : String;
        FSendBuffer           : TBytes;  // FP 09/09/06
        FRequestType          : THttpRequest;
        FReceiveBuffer        : TBytes;  // FP 09/09/06
        FReceiveLen           : Integer;
        FLastResponse         : String;
        FHeaderLineCount      : Integer;
        FBodyStartedFlag      : Boolean;    { V8.67 was FBodyLineCount }
        FAllowedToSend        : Boolean;
        FDelaySetReady        : Boolean;        { 09/26/08 ML }
        FURL                  : String;
        FPath                 : String;
        FDocName              : String;
        FSender               : String;
        FReference            : String;
        FConnection           : String;         { for Keep-alive }
        FProxyConnection      : String;         { for proxy keep-alive }
        FCurrConnection       : String;
        FCurrProxyConnection  : String;
        FAgent                : String;
        FAccept               : String;
        FAcceptLanguage       : String;
        FModifiedSince        : TDateTime;      { Warning ! Use GMT date/Time }
        FNoCache              : Boolean;
        FExtraHeaders         : TStrings;   { V8.52 }
        FStatusCode           : Integer;
        FReasonPhrase         : String;
        FResponseVer          : String;
        FRequestVer           : String;
        FContentLength        : THttpBigInt;
        FContentType          : String;
        FTransferEncoding     : String;
{$IFDEF UseContentCoding}
        FContentEncoding      : String;
        FContentCodingHnd     : THttpContCodHandler;
        FRcvdStreamStartSize  : Integer;
{$ENDIF}
        FChunkLength          : Integer;
        FChunkRcvd            : Integer;
        FChunkState           : THttpChunkState;
        FDoAuthor             : TStringList;
        FWWWAuthInfos         : TWWWAuthInfos;    { V8.69 parsed from FDoAuthor }
        FHttpAuthTypes        : THttpAuthTypes;   { V8.69 parsed from FDoAuthor }
        FContentPost          : String;         { Also used for PUT }
        FContentRangeBegin    : String;
        FContentRangeEnd      : String;
        FContentIfRange       : String;         { V8.68 }
        FResponseEtag         : String;         { V8.68 }
        FReqIfMatch           : String;         { V8.68 }
        FReqIfNoneMatch       : String;         { V8.68 }
        FAcceptRanges         : String;
        FCookie               : String;
        FLocationFlag         : Boolean;
        FFollowRelocation     : Boolean;    {TED}
        FHeaderEndFlag        : Boolean;
        FRcvdHeader           : TStrings;
        FRcvdStream           : TStream;     { If assigned, will recv the answer }
        FRcvdCount            : THttpBigInt; { Number of rcvd bytes for the body }
        FSentCount            : THttpBigInt;
        FSendStream           : TStream; { Contains the data to send         }
        FReqStream            : TMemoryStream;
        FRequestDoneError     : Integer;
        FNext                 : procedure of object;
        FBodyData             : Integer;  // Offset in FReceiveBuffer (FP 09/09/06)
        FBodyDataLen          : THttpBigInt;
        FOptions              : THttpCliOptions;
        FSocksServer          : String;
        FSocksLevel           : String;
        FSocksPort            : String;
        FSocksUsercode        : String;
        FSocksPassword        : String;
        FSocksAuthentication  : TSocksAuthentication;
{$IFDEF UseNTLMAuthentication}
        FAuthNtlmSession      : TNtlmAuthSession;  // V8.61 OAS
        FNTLMMsg2Info         : TNTLM_Msg2_Info;
        FProxyNTLMMsg2Info    : TNTLM_Msg2_Info;
        FAuthNTLMState        : THttpNTLMState;
        FProxyAuthNTLMState   : THttpNTLMState;
        FLmCompatLevel        : LongWord;  { V7.25 }
{$ENDIF}
{$IFDEF UseDigestAuthentication}
        FAuthDigestState      : THttpDigestState;
        FProxyAuthDigestState : THttpDigestState;
        FAuthDigestInfo       : TAuthDigestInfo;
        FAuthDigestProxyInfo  : TAuthDigestInfo;
        { As specified in RFC 2617, section 3.2.2.4, used only with auth-int }
        FAuthDigestEntityHash : THashHex;
{$ENDIF}
        FOnBeforeAuth         : THttpBeforeAuthEvent;
        FAuthBasicState       : THttpBasicState;
        FProxyAuthBasicState  : THttpBasicState;
        FServerAuth           : THttpAuthType;
        FProxyAuth            : THttpAuthType;
{$IF DEFINED(BUILTIN_THROTTLE)}
        FBandwidthLimit       : Integer;  // Bytes per second
        FBandwidthSampling    : Integer;  // mS sampling interval
{$IFEND}
        FOnStateChange        : TNotifyEvent;
        FOnSessionConnected   : TNotifyEvent;
        FOnSessionClosed      : TNotifyEvent;
        FOnRequestHeaderBegin : TNotifyEvent;
        FOnRequestHeaderEnd   : TNotifyEvent;
        FOnHeaderBegin        : TNotifyEvent;
        FOnHeaderEnd          : TNotifyEvent;
        FOnHeaderData         : TNotifyEvent;
        FOnDocBegin           : TNotifyEvent;
        FOnDocEnd             : TNotifyEvent;
        FOnDocData            : TDocDataEvent;
        FOnSendBegin          : TNotifyEvent;
        FOnSendEnd            : TNotifyEvent;
        FOnSendData           : TDocDataEvent;
        FOnTrace              : TNotifyEvent;
        FOnCommand            : TOnCommand;
        FOnCookie             : TCookieRcvdEvent;
        FOnDataPush           : TDataAvailable;
        FOnDataPush2          : TNotifyEvent;
        FOnRequestDone        : THttpRequestDone;
        FOnLocationChange     : TNotifyEvent;
        FLocationChangeMaxCount   : Integer;  {  V1.90 }
        FLocationChangeCurCount   : Integer;  {  V1.90 }
        FOnLocationChangeExceeded : TLocationChangeExceeded;  {  V1.90 }
        { Added by Eugene Mayevski }
        FOnSocksConnected     : TSessionConnected;
        FOnSocksAuthState     : TSocksAuthStateEvent;
        FOnSocksError         : TSocksErrorEvent;
        FOnSocketError        : TNotifyEvent;
        FOnBeforeHeaderSend   : TBeforeHeaderSendEvent;     { Wilfried 9 sep 02}
        FOnSelectDns          : TSelectDnsEvent;            { V8.57 }
        FCloseReq             : Boolean;                    { SAE 01/06/04 }
        FSocketErrs           : TSocketErrs;                { V8.37 }
        FAuthBearerToken      : String;        { V8.54 }
        FResponseNoException  : Boolean;       { V8.54 should error exceptions be skipped? }
        FCurrDnsResult        : Integer;       { V8.60 round robin DNS results }
        FTotDnsResult         : Integer;       { V8.60 round robin DNS results }
        FLastAddrOK           : String;        { V8.60 round robin DNS results }
        FRespDateDT           : TDateTime;     { V8.61 }
        FRespLastModDT        : TDateTime;     { V8.61 }
        FRespExpires          : TDateTime;     { V8.61 }
        FRespAge              : Integer;       { V8.61 }
        FRespCacheControl     : String;        { V8.61 }
        FAlpnProtoList        : TStrings;      { V8.62 only used for SSL }
        FPunyCodeHost         : String;        { V8.64 }
        FAddrResolvedStr      : String;        { V8.66 }
        FTimeout              : UINT;  { V7.04 }            { Sync Timeout Seconds }
        FWMLoginQueued        : Boolean;
        FOnSyncRequestWait    : TOnSyncRequestWaitEvent;       { V8.71 JK }
        procedure AbortComponent(E:Exception); override;    { V8.68 added E to allow reporting }
        procedure AllocateMsgHandlers; override;
        procedure FreeMsgHandlers; override;
        function  MsgHandlersCount: Integer; override;
        procedure CheckDelaySetReady; virtual;              { 09/26/08 ML }
{$IFNDEF NO_DEBUG_LOG}
        function  GetIcsLogger: TIcsLogger;                 { V1.91 }
        procedure SetIcsLogger(const Value: TIcsLogger);    { V1.91 }
        procedure DebugLog(LogOption: TLogOption; const Msg : string); virtual;   { V1.91 }
        function  CheckLogOptions(const LogOption: TLogOption): Boolean; virtual; { V1.91 }
{$ENDIF}
        procedure CreateSocket; virtual;
        procedure DoBeforeConnect; virtual;
        procedure DoSocksConnected(Sender: TObject; ErrCode: Word);
        procedure DoSocksAuthState(Sender : TObject; AuthState : TSocksAuthState);
        procedure DoSocksError(Sender : TObject; ErrCode : Integer; Msg : String);
        procedure SocketErrorTransfer(Sender : TObject);
        procedure SendRequest(const method, Version: String); virtual;
        procedure GetHeaderLineNext; virtual;
        procedure GetBodyLineNext; virtual;
        procedure SendCommand(const Cmd : String); virtual;
        procedure Login; virtual;
        procedure Logout; virtual;
        procedure InternalClear; virtual;
        procedure StartRelocation; virtual;
{$IFDEF UseNTLMAuthentication}
        procedure StartAuthNTLM; virtual;
        procedure StartProxyAuthNTLM; virtual;  {BLD proxy NTLM support }
        function  GetNTLMMessage1(const ForProxy: Boolean) : String;
        function  GetNTLMMessage3(const HttpMethod: String;
            const ForProxy: Boolean): String;
        procedure ElaborateNTLMAuth;
        function  PrepareNTLMAuth(var FlgClean : Boolean) : Boolean;
{$ENDIF}
{$IFDEF UseDigestAuthentication}
        procedure ElaborateDigestAuth;
        function  GetDigestAuthorizationHeader(const HttpMethod: String;
           ProxyAuth : Boolean): String;
        function  PrepareDigestAuth(var FlgClean : Boolean) : Boolean;
        procedure StartAuthDigest; virtual;
        procedure StartProxyAuthDigest; virtual;
{$ENDIF}
        procedure LoginDelayed; {$IFDEF USE_INLINE} inline; {$ENDIF}
        function GetBasicAuthorizationHeader(
            const HttpMethod: String; ProxyAuth: Boolean): String;
        procedure CleanupRcvdStream;
        procedure CleanupSendStream;
        procedure StartAuthBasic; virtual;
        procedure StartProxyAuthBasic; virtual;
        procedure ElaborateBasicAuth;
        function  PrepareBasicAuth(var FlgClean : Boolean) : Boolean;
        procedure SocketDNSLookupDone(Sender: TObject; ErrCode: Word); virtual;
        procedure SocketSessionClosed(Sender: TObject; ErrCode: Word); virtual;
        procedure SocketSessionConnected(Sender : TObject; ErrCode : Word); virtual;
        procedure SocketDataSent(Sender : TObject; ErrCode : Word); virtual;
        procedure SocketDataAvailable(Sender: TObject; ErrCode: Word); virtual;
        procedure LocationSessionClosed(Sender: TObject; ErrCode: Word); virtual;
        procedure DoRequestAsync(Rq : THttpRequest); virtual;
        procedure DoRequestSync(Rq : THttpRequest); virtual;
        procedure SetMultiThreaded(const Value : Boolean); override;
        procedure SetTerminated(const Value: Boolean); override;
        procedure SetOnMessagePump(const Value: TNotifyEvent); override;
        procedure SetOnBgException(const Value: TIcsBgExceptionEvent); override; { V7.11 }
        procedure StateChange(NewState : THttpState); virtual;
        procedure TriggerStateChange; virtual;
        procedure TriggerCookie(const Data : String;
                                var   bAccept : Boolean); virtual;
        procedure TriggerSessionConnected; virtual;
        procedure TriggerSessionClosed; virtual;
        procedure TriggerBeforeHeaderSend(const Method : String;
                                          Headers : TStrings); virtual;
        procedure TriggerRequestHeaderBegin; virtual;
        procedure TriggerRequestHeaderEnd; virtual;
        procedure TriggerHeaderBegin; virtual;
        procedure TriggerHeaderEnd; virtual;
        procedure TriggerHeaderFieldData(var AHeaderField, AHeaderData: String); virtual;  { V8.71 JK }
        procedure TriggerDocBegin; virtual;
        procedure TriggerDocData(Data : Pointer; Len : Integer); virtual;
        procedure TriggerDocEnd; virtual;
        procedure TriggerSendBegin; virtual;
        procedure TriggerSendData(Data : Pointer; Len : Integer); virtual;
        procedure TriggerSendEnd; virtual;
        procedure TriggerRequestDone; virtual;
        procedure WndProc(var MsgRec: TMessage); override;
        procedure SetReady; virtual;
        procedure AdjustDocName; virtual;
        function  GetProtocolPort(const AProtocol: String): String; virtual;  { V8.71 JK }
        function  IsSSLProtocol(const AProtocol: String): Boolean; virtual;   { V8.71 JK }
        function  IsKnownProtocol(const AProtocol: String): Boolean; virtual; { V8.71 JK }
        function  IsKnownProtocolURL(const AURL : String): Boolean; virtual;  { V8.71 JK }
        procedure SetRequestVer(const Ver : String);
        procedure SetExtraHeaders(Value: TStrings);      { V8.52 }
        procedure SetSocketFamily(Value : TSocketFamily); { V8.60 }
        procedure TriggerRequestDone2; virtual; { V8.61 so we can override it }
        procedure TriggerCommand(var S: String); virtual;  { V8.61 }
        procedure TriggerHeaderData; virtual;  { V8.61 }
        procedure TriggerLocationChange; virtual;  { V8.61 }
        function  GetRequestDoneErrorStr: String;  { V8.68 }
        procedure WMHttpRequestDone(var msg: TMessage);
        procedure WMHttpSetReady(var msg: TMessage);
        procedure WMHttpLogin(var msg: TMessage);
{$IFDEF UseContentCoding}
        function  GetOptions: THttpCliOptions;
        procedure SetOptions(const Value : THttpCliOptions);
{$ENDIF}
{$IFDEF USE_SSL}
        procedure SslHandshakeDone(Sender         : TObject;
                                   ErrCode        : Word;
                                   PeerCert       : TX509Base;
                                   var Disconnect : Boolean);
        procedure TransferSslHandshakeDone(Sender      : TObject;
                                            ErrCode    : Word;
                                            PeerCert   : TX509Base;
                                        var Disconnect : Boolean); virtual; { V8.61 }
{$ENDIF}
    public
        constructor Create(AOwner: TComponent); override;
        destructor  Destroy; override;
        procedure   Get;        { Synchronous blocking Get         }
        procedure   Post;       { Synchronous blocking Post        }
        procedure   Put;        { Synchronous blocking Put         }
        procedure   Patch;      { Synchronous blocking Patch V8.06 }
        procedure   OptionsSync;    { Synchronous blocking Options V8.09 - warning Options exists already }
        procedure   Trace;      { Synchronous blocking Trace   V8.09 }
        procedure   Head;       { Synchronous blocking Head        }
        procedure   Del;        { Synchronous blocking Delete      }
        procedure   Close;      { Synchronous blocking Close       }
        procedure   Abort;      { Synchrounous blocking Abort      }
        procedure   GetASync;   { Asynchronous, non-blocking Get   }
        procedure   PostASync;  { Asynchronous, non-blocking Post  }
        procedure   PutASync;   { Asynchronous, non-blocking Put   }
        procedure   PatchAsync; { Asynchronous, non-blocking Patch V8.06 }
        procedure   OptionsAsync; { Asynchronous, non-blocking Options V8.09 }
        procedure   TraceAsync;   { Asynchronous, non-blocking Trace V8.09   }
        procedure   HeadASync;  { Asynchronous, non-blocking Head  }
        procedure   DelASync;   { Asynchronous, non-blocking Delete}
        procedure   CloseAsync; { Asynchronous, non-blocking Close }
        procedure   ThreadAttach; override;
        procedure   ThreadDetach; override;
        procedure   RequestAsync(Rq :THttpRequest);                               { V8.69 }
        procedure   RequestSync(Rq :THttpRequest);                                { V8.69 }
        function    FindAuthType(AType: THttpAuthType): Integer;                  { V8.69 find WWWAuthInfos record with required authentication type }
        property CtrlSocket           : TWSocket     read  FCtrlSocket;
        //property Handle               : HWND         read  FWindowHandle;
        property State                : THttpState   read  FState;
        property Connected            : Boolean      read  FConnected;  { V8.54 }
        property RequestDoneErrorStr  : String       read  GetRequestDoneErrorStr;  { V8.68 }
        property RequestDoneError     : Integer      read  FRequestDoneError;       { V8.68 }
        property LastResponse         : String       read  FLastResponse;
        property ContentLength        : THttpBigInt  read  FContentLength;
        property ContentType          : String       read  FContentType;
        property TransferEncoding     : String       read  FTransferEncoding;
{$IFDEF UseContentCoding}
        property ContentEncoding      : String       read  FContentEncoding;
        property ContentCodingHnd     : THttpContCodHandler read FContentCodingHnd;
{$ENDIF}
        property RcvdCount            : THttpBigInt  read  FRcvdCount;
        property SentCount            : THttpBigInt  read  FSentCount;
        property StatusCode           : Integer      read  FStatusCode;
        property ReasonPhrase         : String       read  FReasonPhrase;
        property DnsResult            : String       read  FDnsResult;
        property AddrResolvedStr      : String       read  FAddrResolvedStr;      { V8.60 }
        property PunyCodeHost         : String       read  FPunyCodeHost;         { V8.64 }
        property RespDateDT           : TDateTime    read  FRespDateDT ;          { V8.61 }
        property RespLastModDT        : TDateTime    read  FRespLastModDT ;       { V8.61 }
        property RespExpires          : TDateTime    read  FRespExpires;          { V8.61 }
        property RespAge              : Integer      read  FRespAge;              { V8.61 }
        property RespCacheControl     : String       read  FRespCacheControl;     { V8.61 }
        property AuthorizationRequest : TStringList  read  FDoAuthor;
        property WWWAuthInfos         : TWWWAuthInfos  read FWWWAuthInfos;        { V8.69 parsed from FDoAuthor }
        property HttpAuthTypes        : THttpAuthTypes read FHttpAuthTypes;       { V8.69 parsed from FDoAuthor }
        property DocName              : String       read  FDocName;
        property Location             : String       read  FLocation
                                                     write FLocation;
        property RcvdStream           : TStream      read  FRcvdStream
                                                     write FRcvdStream;
        property SendStream           : TStream      read  FSendStream
                                                     write FSendStream;
        property RcvdHeader           : TStrings     read  FRcvdHeader;
        property Hostname             : String       read  FHostname;
        property Protocol             : String       read  FProtocol;
        property RequestType          : THttpRequest read  FRequestType;   { V8.09 }
{$IFDEF UseDigestAuthentication}
        property AuthDigestInfo       : TAuthDigestInfo
                                                     read  FAuthDigestInfo
                                                     write FAuthDigestInfo;
        property AuthDigestProxyInfo  : TAuthDigestInfo
                                                     read  FAuthDigestProxyInfo
                                                     write FAuthDigestProxyInfo;
        property AuthDigestEntityHash : THashHex     read  FAuthDigestEntityHash
                                                     write FAuthDigestEntityHash;
{$ENDIF}
    published
        property URL             : String            read  FURL
                                                     write FURL;
        property LocalAddr       : String            read  FLocalAddr   {bb}
                                                     write FLocalAddr;  {bb}
        property LocalAddr6      : String            read  FLocalAddr6
                                                     write FLocalAddr6; { V8.02 }
        property Proxy           : String            read  FProxy
                                                     write FProxy;
        property ProxyPort       : String            read  FProxyPort
                                                     write FProxyPort;
        property Sender          : String            read  FSender
                                                     write FSender;
        property Agent           : String            read  FAgent
                                                     write FAgent;
        property Accept          : String            read  FAccept
                                                     write FAccept;
        property AcceptLanguage  : String            read  FAcceptLanguage
                                                     write FAcceptLanguage;
        property Reference       : String            read  FReference
                                                     write FReference;
        property Connection      : String            read  FConnection
                                                     write FConnection;
        property ProxyConnection : String            read  FProxyConnection
                                                     write FProxyConnection;
        property Username        : String            read  FUsername
                                                     write FUsername;
        property Password        : String            read  FPassword
                                                     write FPassword;
        property ProxyUsername   : String            read  FProxyUsername
                                                     write FProxyUsername;
        property ProxyPassword   : String            read  FProxyPassword
                                                     write FProxyPassword;
        property ProxyURL        : String            read  FProxyURL
                                                     write FProxyURL;            { V8.62 }
        property NoCache         : Boolean           read  FNoCache
                                                     write FNoCache;
        property ModifiedSince   : TDateTime         read  FModifiedSince
                                                     write FModifiedSince;
        property Cookie          : String            read  FCookie
                                                     write FCookie;
        property ExtraHeaders    : TStrings          read  FExtraHeaders
                                                     write SetExtraHeaders;       { V8.52 }
        property ResponseNoException : Boolean       read  FResponseNoException
                                                     write FResponseNoException;  { V8.54 }
        property ContentTypePost : String            read  FContentPost
                                                     write FContentPost;
        property ContentRangeBegin: String           read  FContentRangeBegin  {JMR!! Added this line!!!}
                                                     write FContentRangeBegin; {JMR!! Added this line!!!}
        property ContentRangeEnd  : String           read  FContentRangeEnd    {JMR!! Added this line!!!}
                                                     write FContentRangeEnd;   {JMR!! Added this line!!!}
        property ContentIfRange   : String           read  FContentIfRange
                                                     write FContentIfRange;    { V8.68 }
        property ReqIfMatch       : String           read  FReqIfMatch
                                                     write FReqIfMatch;        { V8.68 }
        property ReqIfNoneMatch   : String           read  FReqIfNoneMatch
                                                     write FReqIfNoneMatch;    { V8.68 }
        property AcceptRanges     : String           read  FAcceptRanges;
        property ResponseEtag     : String           read  FResponseEtag;      { V8.68 }
{$IFDEF UseNTLMAuthentication}
        property LmCompatLevel    : LongWord         read  FLmCompatLevel   { V7.25 }
                                                     write FLmCompatLevel; { V8.71 now published rather tjan private }
{$ENDIF}
        property MultiThreaded;
        property RequestVer       : String           read  FRequestVer
                                                     write SetRequestVer;
        property FollowRelocation : Boolean          read  FFollowRelocation   {TED}
                                                     write FFollowRelocation;  {TED}
        property LocationChangeMaxCount: integer     read  FLocationChangeMaxCount   {  V1.90 }
                                                     write FLocationChangeMaxCount ;
        property LocationChangeCurCount: integer     read FLocationChangeCurCount ;  {  V1.90 }
        property OnLocationChangeExceeded: TLocationChangeExceeded
                                                     read FOnLocationChangeExceeded  {  V1.90 }
                                                     write FOnLocationChangeExceeded ;
{ ServerAuth and ProxyAuth properties are still experimental. They are likely
  to change in the future. If you use them now, be prepared to update your
  code later }
        property ServerAuth       : THttpAuthType    read  FServerAuth
                                                     write FServerAuth;
        property ProxyAuth        : THttpAuthType    read  FProxyAuth
                                                     write FProxyAuth;
{$IF DEFINED(BUILTIN_THROTTLE)}
        property BandwidthLimit       : Integer      read  FBandwidthLimit
                                                     write FBandwidthLimit;
        property BandwidthSampling    : Integer      read  FBandwidthSampling
                                                     write FBandwidthSampling;
{$IFEND}
{$IFDEF UseContentCoding}
        property Options          : THttpCliOptions  read  GetOptions
                                                     write SetOptions;
{$ELSE}
        property Options          : THttpCliOptions  read  FOptions
                                                     write FOptions;
{$ENDIF}
{$IFNDEF NO_DEBUG_LOG}
        property IcsLogger          : TIcsLogger     read  GetIcsLogger   { V1.91 }
                                                     write SetIcsLogger;
{$ENDIF}
        property Timeout            : UINT           read  FTimeout { V7.04 sync only! }
                                                     write FTimeout;
        property OnTrace            : TNotifyEvent   read  FOnTrace
                                                     write FOnTrace;
        property OnSessionConnected : TNotifyEvent   read  FOnSessionConnected
                                                     write FOnSessionConnected;
        property OnSessionClosed    : TNotifyEvent   read  FOnSessionClosed
                                                     write FOnSessionClosed;
        property OnHeaderData       : TNotifyEvent   read  FOnHeaderData
                                                     write FOnHeaderData;
        property OnCommand          : TOnCommand     read  FOnCommand
                                                     write FOnCommand;
        property OnHeaderBegin      : TNotifyEvent   read  FOnHeaderBegin
                                                     write FOnHeaderBegin;
        property OnHeaderEnd        : TNotifyEvent   read  FOnHeaderEnd
                                                     write FOnHeaderEnd;
        property OnRequestHeaderBegin : TNotifyEvent read  FOnRequestHeaderBegin
                                                     write FOnRequestHeaderBegin;
        property OnRequestHeaderEnd   : TNotifyEvent read  FOnRequestHeaderEnd
                                                     write FOnRequestHeaderEnd;
        property OnDocBegin      : TNotifyEvent      read  FOnDocBegin
                                                     write FOnDocBegin;
        property OnDocData       : TDocDataEvent     read  FOnDocData
                                                     write FOnDocData;
        property OnDocEnd        : TNotifyEvent      read  FOnDocEnd
                                                     write FOnDocEnd;
        property OnSendBegin     : TNotifyEvent      read  FOnSendBegin
                                                     write FOnSendBegin;
        property OnSendData      : TDocDataEvent     read  FOnSendData
                                                     write FOnSendData;
        property OnSendEnd       : TNotifyEvent      read  FOnSendEnd
                                                     write FOnSendEnd;
        property OnStateChange   : TNotifyEvent      read  FOnStateChange
                                                     write FOnStateChange;
        property OnRequestDone   : THttpRequestDone  read  FOnRequestDone
                                                     write FOnRequestDone;
        property OnLocationChange : TNotifyEvent     read  FOnLocationChange
                                                     write FOnLocationChange;
        property OnCookie         : TCookieRcvdEvent read  FOnCookie
                                                     write FOnCookie;
        property OnDataPush       : TDataAvailable   read  FOnDataPush
                                                     write FOnDataPush;
        property OnDataPush2      : TNotifyEvent     read  FOnDataPush2
                                                     write FOnDataPush2;
        property SocksServer      : String           read  FSocksServer
                                                     write FSocksServer;
        property SocksLevel       : String           read  FSocksLevel
                                                     write FSocksLevel;
        property SocksPort        : String           read  FSocksPort
                                                     write FSocksPort;
        property SocksUsercode    : String           read  FSocksUsercode
                                                     write FSocksUsercode;
        property SocksPassword    : String           read  FSocksPassword
                                                     write FSocksPassword;
        property SocksAuthentication : TSocksAuthentication
                                                     read  FSocksAuthentication
                                                     write FSocksAuthentication;
        property OnSocksConnected    : TSessionConnected
                                                     read FOnSocksConnected
                                                     write FOnSocksConnected;
        property OnSocksAuthState    : TSocksAuthStateEvent
                                                     read FOnSocksAuthState
                                                     write FOnSocksAuthState;
        property OnSocksError        : TSocksErrorEvent
                                                     read FOnSocksError
                                                     write FOnSocksError;
        property OnSocketError       : TNotifyEvent  read FOnSocketError
                                                     write FOnSocketError;
        property OnBeforeHeaderSend  : TBeforeHeaderSendEvent
                                                     read  FOnBeforeHeaderSend
                                                     write FOnBeforeHeaderSend;
        property OnBeforeAuth        : THttpBeforeAuthEvent
                                                     read  FOnBeforeAuth
                                                     write FOnBeforeAuth;
        property OnBgException;                                             { V7.11 }
        property SocketFamily        : TSocketFamily read  FSocketFamily
                                                     write SetSocketFamily;  { V8.60 }
        property SocketErrs          : TSocketErrs    read  FSocketErrs
                                                     write FSocketErrs;      { V8.37 }
        property AuthBearerToken     : String        read  FAuthBearerToken
                                                     write FAuthBearerToken; { V8.54 }
        property OnSelectDns         : TSelectDnsEvent
                                                     read  FOnSelectDns
                                                     write FOnSelectDns;     { V8.57 }
        property OnSyncRequestWait : TOnSyncRequestWaitEvent read  FOnSyncRequestWait
                                                             write FOnSyncRequestWait;  { V8.71 JK }
    end;

{ You must define USE_SSL so that SSL code is included in the component.   }
{ Either in OverbyteIcsDefs.inc or in the project/package options.         }
{$IFDEF USE_SSL}
{*_* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

Description:  A component adding SSL support to THttpCli.
              Requires OpenSSL (http://www.openssl.org).
              More details in ReadMeIcsSsl.txt and IcsSslHowTo.txt.
              SSL demo applications can be found in /Delphi/SslInternet.
              If you use Delphi 7 and later, you may want to disable warnings
              for unsage type, unsafe code and unsafe typecast in the project
              options. Those warning are intended for .NET programs. You may
              also want to turn off deprecated symbol and platform symbol
              warnings.

 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{$B-}                                 { Enable partial boolean evaluation   }
{$T-}                                 { Untyped pointers                    }
{$X+}                                 { Enable extended syntax              }
{$H+}                                 { Use long strings                    }
{$J+}                                 { Allow typed constant to be modified }
type
    TSslHttpCli = class(THttpCli)
    protected
        FOnSslVerifyPeer : TSslVerifyPeerEvent;
        FOnSslCliGetSession     : TSslCliGetSession;
        FOnSslCliNewSession     : TSslCliNewSession;
        FOnSslHandshakeDone     : TSslHandshakeDoneEvent;
        FOnSslCliCertRequest    : TSslCliCertRequest;
        procedure CreateSocket; override;
        procedure DoBeforeConnect; override;
        procedure SetSslContext(Value: TSslContext);
        function  GetSslContext: TSslContext;
        procedure SetSslAcceptableHosts(Value : TStrings);
        function  GetSslAcceptableHosts: TStrings;
        procedure SetAlpnProtocols(ProtoList: TStrings);               { V8.62 }

        procedure TransferSslVerifyPeer(Sender        : TObject;
                                        var Ok        : Integer;
                                        Cert           : TX509Base); virtual;
        procedure TransferSslCliGetSession(Sender      : TObject;
                                       var SslSession  : Pointer;
                                      var FreeSession  : Boolean); virtual;
        procedure TransferSslCliNewSession(Sender      : TObject;
                                          SslSession   : Pointer;
                                          WasReused    : Boolean;
                                      var IncRefCount  : Boolean); virtual;
        procedure TransferSslCliCertRequest(Sender     : TObject;
                                            var Cert   : TX509Base); virtual;
    public
        procedure   SetAcceptableHostsList(const SemiColonSeparatedList : String);
        function    GetAlpnProtocol: String;
    published
        property SslContext         : TSslContext         read  GetSslContext
                                                          write SetSslContext;
        property SslAcceptableHosts : TStrings            read  GetSslAcceptableHosts
                                                          write SetSslAcceptableHosts;
        property AlpnProtocols      : TStrings            read  FAlpnProtoList
                                                          write SetAlpnProtocols; { V8.62 }
        property OnSslVerifyPeer    : TSslVerifyPeerEvent read  FOnSslVerifyPeer
                                                          write FOnSslVerifyPeer;
        property OnSslCliGetSession : TSslCliGetSession
                                                          read  FOnSslCliGetSession
                                                          write FOnSslCliGetSession;
        property OnSslCliNewSession : TSslCliNewSession
                                                          read  FOnSslCliNewSession
                                                          write FOnSslCliNewSession;
        property OnSslHandshakeDone : TSslHandshakeDoneEvent
                                                          read  FOnSslHandshakeDone
                                                          write FOnSslHandshakeDone;
        property OnSslCliCertRequest : TSslCliCertRequest read  FOnSslCliCertRequest
                                                          write FOnSslCliCertRequest;
    end;

{$ENDIF} // USE_SSL

procedure ReplaceExt(var FName : String; const newExt : String);
{function RFC1123_Date(aDate : TDateTime) : String;
function RFC1123_StrToDate(aDate : String) : TDateTime;  }
function EncodeLine(
    Encoding : THttpEncoding;
    SrcData  : PAnsiChar;
    Size     : Integer) : AnsiString;
function EncodeStr(
    Encoding    : THttpEncoding;
    const Value : RawByteString) : RawByteString; overload;
function EncodeStr(
    Encoding    : THttpEncoding;
    const Value : UnicodeString;
    ACodePage   : LongWord = CP_ACP ) : UnicodeString; overload;

implementation

const
    bin2uue  : AnsiString = '`!"#$%&''()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_';
    bin2b64  : AnsiString = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';
    uue2bin  : AnsiString = ' !"#$%&''()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_ ';
    b642bin  : AnsiString = '~~~~~~~~~~~^~~~_TUVWXYZ[\]~~~|~~~ !"#$%&''()*+,-./0123456789~~~~~~:;<=>?@ABCDEFGHIJKLMNOPQRS';
    linesize = 45;
type
    TCharSet = set of AnsiChar;
const
    UriProtocolSchemeAllowedChars : TCharSet = ['a'..'z','0'..'9','+','-','.'];

function GetBaseUrl(const Url : String) : String; forward;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{$IFDEF DEBUG_OUTPUT}
procedure OutputDebugString(const Msg : String);
begin
    if IsConsole then
        WriteLn(Msg);
end;
{$ENDIF}


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
constructor EHttpException.Create(const Msg : String; ErrCode : Word);
begin
    inherited Create(Msg);
    FErrorCode := ErrCode;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function THttpCli.MsgHandlersCount : Integer;
begin
    Result := 3 + inherited MsgHandlersCount;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure THttpCli.AllocateMsgHandlers;
begin
    inherited AllocateMsgHandlers;
    FMsg_WM_HTTP_REQUEST_DONE := FWndHandler.AllocateMsgHandler(Self);
    FMsg_WM_HTTP_SET_READY    := FWndHandler.AllocateMsgHandler(Self);
    FMsg_WM_HTTP_LOGIN        := FWndHandler.AllocateMsgHandler(Self);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure THttpCli.FreeMsgHandlers;
begin
    if Assigned(FWndHandler) then begin
        FWndHandler.UnregisterMessage(FMsg_WM_HTTP_REQUEST_DONE);
        FWndHandler.UnregisterMessage(FMsg_WM_HTTP_SET_READY);
        FWndHandler.UnregisterMessage(FMsg_WM_HTTP_LOGIN);
    end;
    inherited FreeMsgHandlers;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
constructor THttpCli.Create(AOwner:TComponent);
begin
    inherited Create(AOwner);
    AllocateHWnd;
    FProxyPort                     := DefaultProxyPort;
    FRequestVer                    := '1.0';
    FContentPost                   := 'application/x-www-form-urlencoded';
    FAccept                        := 'image/gif, image/x-xbitmap, ' +
                                      'image/jpeg, image/pjpeg, */*';
    FAgent                         := 'Mozilla/4.0'; { V8.04 removed (compatible; ICS) which upset some servers  }
    FDoAuthor                      := TStringlist.Create;
    FRcvdHeader                    := TStringList.Create;
    FExtraHeaders                  := TStringList.Create;      { V8.52 }
    FReqStream                     := TMemoryStream.Create;
    FState                         := httpReady;
    FLocalAddr                     := ICS_ANY_HOST_V4;
    FLocalAddr6                    := ICS_ANY_HOST_V6;  { V8.02 }
    FFollowRelocation              := TRUE;      {TT 29 sept 2003}
    FOnSyncRequestWait             := nil;       { V8.71 JK }
{$IFDEF UseContentCoding}
    FContentCodingHnd              := THttpContCodHandler.Create(@FRcvdStream,
                                                                 TriggerDocData);
    GetOptions;
{$ENDIF}
    CreateSocket;
    FCtrlSocket.ExceptAbortProc    := AbortComponent; { V7.11 }
    FCtrlSocket.OnSessionClosed    := SocketSessionClosed;
    FCtrlSocket.OnDataAvailable    := SocketDataAvailable;
    FCtrlSocket.OnSessionConnected := SocketSessionConnected;
    FCtrlSocket.OnDataSent         := SocketDataSent;
    FCtrlSocket.OnDnsLookupDone    := SocketDNSLookupDone;
    FCtrlSocket.OnSocksError       := DoSocksError;
    FCtrlSocket.OnSocksConnected   := DoSocksConnected;
    FCtrlSocket.OnSocksAuthState   := DoSocksAuthState;   { V8.51 }
   { V8.37 don't suppress socket exceptions unless we handle them }
    if Assigned (FOnSocketError) then
        FCtrlSocket.OnError        := SocketErrorTransfer;
{$IF DEFINED(BUILTIN_THROTTLE)}
    FBandwidthLimit                := 10000;  { Bytes per second     }
    FBandwidthSampling             := 1000;   { mS sampling interval }
{$IFEND}
    FLocationChangeMaxCount        := 5;  {  V1.90 }
    FLocationChangeCurCount        := 0;  {  V1.90 }
    FTimeOut                       := 30;  { Seconds }
    FSocketFamily                  := DefaultSocketFamily;   { V8.00 }
    FSocksLevel                    := FCtrlSocket.SocksLevel; { V8.71 JK synchronize FSocksLevel with default FCtrlSocket.SocksLevel  }
    FLastAddrOK                    := '';     { V8.60 }
    FCurrDnsResult                 := -1;     { V8.60 }
    FAlpnProtoList                 := TStringList.Create;  { V8.62 }
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
destructor THttpCli.Destroy;
begin
    try       { V8.71 JK ensure inherited destroy called, check assigned before free }
        if Assigned(FDoAuthor) then
            FreeAndNil(FDoAuthor);
        if Assigned(FCtrlSocket) then
            FreeAndNil(FCtrlSocket);
        if Assigned(FAlpnProtoList) then
            FreeAndNil(FAlpnProtoList);     { V8.62 }
        if Assigned(FRcvdHeader) then
            FreeAndNil(FRcvdHeader);
        if Assigned(FExtraHeaders) then
            FreeAndNil(FExtraHeaders);      { V8.52 }
        if Assigned(FReqStream) then
            FreeAndNil(FReqStream);
        SetLength(FReceiveBuffer, 0);   {AG 03/18/07}
        SetLength(FSendBuffer, 0);      {AG 03/18/07}
{$IFDEF UseContentCoding}
        if Assigned(FContentCodingHnd) then
            FreeAndNil(FContentCodingHnd);
{$ENDIF}
{$IFDEF USE_NTLM_AUTH}
        if Assigned(FAuthNtlmSession) then
            FreeAndNil(FAuthNtlmSession);  // V8.61
{$ENDIF}
    finally
        inherited Destroy;
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function THttpCli.GetRequestDoneErrorStr: String;  { V8.68 }
begin
    case FRequestDoneError of
        httperrNoError: Result := 'No Error';
        httperrBusy: Result := 'Busy';
        httperrNoData: Result := 'No Data';
        httperrAborted: Result := 'Aborted';
        httperrOverflow: Result := 'Overflow';
        httperrVersion: Result := 'Version';
        httperrInvalidAuthState: Result := 'Invalid Auth State';
        httperrSslHandShake: Result := 'SSL Handshake';
        httperrCustomTimeOut: Result := 'Custom Timeout';
        httperrNoStatusCode: Result := 'No Status Code';
        httperrOutOfMemory: Result := 'Out of Memory';
        httperrBgException: Result := 'BgException';
    else
        Result := WSocketErrorMsgFromErrorCode(FRequestDoneError);    { V8.69 }
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure THttpCli.CreateSocket;
begin
    FCtrlSocket := TWSocket.Create(nil);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure THttpCli.WndProc(var MsgRec: TMessage);
begin
    try { V7.11 }
        with MsgRec do begin
            if Msg = FMsg_WM_HTTP_REQUEST_DONE then
                WMHttpRequestDone(MsgRec)
            else if Msg = FMsg_WM_HTTP_SET_READY then
                WMHttpSetReady(MsgRec)
            else if Msg = FMsg_WM_HTTP_LOGIN then
                WMHttpLogin(MsgRec)
            else
                inherited WndProc(MsgRec);
        end;
    except { V7.11 }
        on E: Exception do
            HandleBackGroundException(E);
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure THttpCli.DoSocksConnected(Sender: TObject; ErrCode: Word);
begin
    if Assigned(FOnSocksConnected) then
        FOnSocksConnected(Sender, ErrCode);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure THttpCli.SocketErrorTransfer(Sender : TObject);
begin
    if (assigned(FOnSocketError)) then
        FOnSocketError(Self);  { Substitute Self for subcomponent's Sender. }
end;  { SocketErrorTransfer }


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure THttpCli.DoSocksAuthState(
    Sender    : TObject;
    AuthState : TSocksAuthState);
begin
    if Assigned(FOnSocksAuthState) then
        FOnSocksAuthState(Sender, AuthState);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure THttpCli.DoSocksError(
    Sender  : TObject;
    ErrCode : Integer;
    Msg     : String);
begin
    if Assigned(FOnSocksError) then
        FOnSocksError(Sender, ErrCode, Msg);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure THttpCli.SetMultiThreaded(const Value : Boolean);
begin
    if Assigned(FCtrlSocket) then
        FCtrlSocket.MultiThreaded := Value;
    inherited SetMultiThreaded(Value);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure THttpCli.SetTerminated(const Value: Boolean);
begin
    if Assigned(FCtrlSocket) then
        FCtrlSocket.Terminated := Value;
    inherited SetTerminated(Value);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure THttpCli.SetOnBgException(const Value: TIcsBgExceptionEvent); { V7.11 }
begin
    if Assigned(FCtrlSocket) then
        FCtrlSocket.OnBgException := Value;
    inherited SetOnBgException(Value);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure THttpCli.SetOnMessagePump(const Value: TNotifyEvent);
begin
    if Assigned(FCtrlSocket) then
        FCtrlSocket.OnMessagePump := Value;
    inherited SetOnMessagePump(Value);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure THttpCli.SetReady;
begin
    PostMessage(Handle, FMsg_WM_HTTP_SET_READY, 0, 0);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure THttpCli.SetExtraHeaders(Value : TStrings);    { V8.52 }
begin
    FExtraHeaders.Assign(Value);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure THttpCli.SetSocketFamily(Value : TSocketFamily); { V8.60 }
begin
    if FSocketFamily <> Value then begin
        FSocketFamily := Value;
        FLastAddrOK  := '';   { ensure we don't use last IP address again }
        FCurrDnsResult := -1;
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function THttpCli.FindAuthType(AType: THttpAuthType): Integer;   { V8.69 find record with required authentication type }
begin
    Result := -1;
    if  Length(FWWWAuthInfos) = 0 then Exit;
    for Result := 0 to Length(FWWWAuthInfos) - 1 do begin
        if FWWWAuthInfos[Result].AuthType = AType then Exit;
    end;
    Result := -1;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure THttpCli.StateChange(NewState : THttpState);
var
    FlgClean : Boolean;
    SaveDoc, S: String;
    I, J: Integer;
begin
    if FState <> NewState then begin
        FState := NewState;
        TriggerStateChange;
        if (NewState = httpReady) then begin

            { We must elaborate the result of started authentications
              before a new preparation }

     { V8.69 build array by parsing WWW-Authenticate headers, so user knows what options the server offers and can select one }
     { currently assuming each header only has a single authentication scheme, the specs say they may be more one comma separated }
            if (FDoAuthor.Count > 0) then begin
                if Length(FWWWAuthInfos) = 0 then begin
                    FHttpAuthTypes := [];
                    SetLength(FWWWAuthInfos, FDoAuthor.Count);
                    for I := 0 to FDoAuthor.Count - 1 do begin
                        FWWWAuthInfos[I].Header := FDoAuthor.Strings[I];  // full header line, needed for NTLM and digest
                        S := Lowercase(FDoAuthor.Strings[I]);
                        FWWWAuthInfos[I].AuthType := httpAuthNone;
                        if Pos ('basic', S) = 1 then
                            FWWWAuthInfos[I].AuthType := httpAuthBasic;
                        if Pos ('digest', S) = 1 then begin
                            if Pos ('-256', S) > 1 then
                                FWWWAuthInfos[I].AuthType := httpAuthDigest2
                            else
                                FWWWAuthInfos[I].AuthType := httpAuthDigest;
                        end;
                        if Pos ('ntlm', S) = 1 then
                            FWWWAuthInfos[I].AuthType := httpAuthNtlm;
                        J := Pos ('realm="', S);
                        if J > 1 then begin
                            FWWWAuthInfos[I].Realm := Copy(FDoAuthor.Strings[I], J + 7, 999);
                            J := Pos ('"', FWWWAuthInfos[I].Realm);
                            if J > 0 then SetLength(FWWWAuthInfos[I].Realm, J - 1);
                        end
                        else
                            FWWWAuthInfos[I].Realm := URL;
                        J := Pos ('charset="', S);
                        if J > 1 then begin
                            FWWWAuthInfos[I].Charset := Copy(FDoAuthor.Strings[I], J + 9, 999);
                            J := Pos ('"', FWWWAuthInfos[I].CharSet);
                            if J > 0 then SetLength(FWWWAuthInfos[I].CharSet, J - 1);
                        end;
                        J := Pos ('uri="', S);
                        if J > 1 then begin
                            FWWWAuthInfos[I].Uri := Copy(FDoAuthor.Strings[I], J + 7, 999);
                            J := Pos ('"', FWWWAuthInfos[I].Uri);
                            if J > 0 then SetLength(FWWWAuthInfos[I].Uri, J - 1);
                        end
                        else
                            FWWWAuthInfos[I].Uri := URL;
                        FHttpAuthTypes := FHttpAuthTypes + [FWWWAuthInfos[I].AuthType]; { simple auth set }
                    end;
                end;
            end;

        {$IFDEF UseNTLMAuthentication}
            ElaborateNTLMAuth;
        {$ENDIF}
        {$IFDEF UseDigestAuthentication}
            ElaborateDigestAuth;
        {$ENDIF}
            ElaborateBasicAuth;

            FlgClean := False;
    {$IFDEF UseNTLMAuthentication}
            if PrepareNTLMAuth(FlgClean) or
        {$IFDEF UseDigestAuthentication}
                PrepareDigestAuth(FlgClean) or
        {$ENDIF}
                PrepareBasicAuth(FlgClean) then begin
    {$ELSE}
        {$IFDEF UseDigestAuthentication}
            if PrepareDigestAuth(FlgClean) or PrepareBasicAuth(FlgClean) then begin
        {$ELSE}
            if PrepareBasicAuth(FlgClean) then begin
        {$ENDIF}
    {$ENDIF}
                if FStatusCode = 401 then begin
                    { If the connection will be closed or is already closed
                      then check if we must repeat a proxy authentication,
                      otherwise we must clear it }
                    if FCloseReq or (FCtrlSocket.State = wsClosed) then begin
                    {$IFDEF UseNTLMAuthentication}
                        if FProxyAuthNTLMState = ntlmDone then
                            FProxyAuthNTLMState := ntlmMsg1
                        else
                    {$ENDIF}
                    {$IFDEF UseDigestAuthentication}
                        if FProxyAuthDigestState = digestDone then
                            FProxyAuthDigestState := digestMsg1
                        else
                    {$ENDIF}
                        if FProxyAuthBasicState = basicDone then
                            FProxyAuthBasicState := basicMsg1;
                    end
                    else begin
                    {$IFDEF UseNTLMAuthentication}
                        if FProxyAuthNTLMState < ntlmDone then
                            FProxyAuthNTLMState := ntlmNone
                        else
                    {$ENDIF}
                    {$IFDEF UseDigestAuthentication}
                        if FProxyAuthDigestState < digestDone then
                            FProxyAuthDigestState := digestNone
                        else
                    {$ENDIF}
                        if FProxyAuthBasicState < basicDone then
                            FProxyAuthBasicState := basicNone;
                    end;
                end;

                if FlgClean then begin
                    CleanupRcvdStream; { What we are received must be removed }
                    CleanupSendStream;
                    FReceiveLen       := 0;
                    SaveDoc           := FDocName;
                    InternalClear;
                    FDocName          := SaveDoc;
                end;
            end
            else
                TriggerRequestDone;
        end;
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure THttpCli.TriggerStateChange;
begin
{$IFNDEF NO_DEBUG_LOG}
    if CheckLogOptions(loProtSpecInfo) then begin  { V1.91 } { replaces $IFDEF DEBUG_OUTPUT  }
    case FState of
          httpReady               : DebugLog(loProtSpecInfo, 'State = httpReady');
          httpNotConnected        : DebugLog(loProtSpecInfo, 'State = httpNotConnected');
          httpConnected           : DebugLog(loProtSpecInfo, 'State = httpConnected');
          httpDnsLookup           : DebugLog(loProtSpecInfo, 'State = httpDnsLookup');
          httpDnsLookupDone       : DebugLog(loProtSpecInfo, 'State = httpDnsLookupDone');
          httpWaitingHeader       : DebugLog(loProtSpecInfo, 'State = httpWaitingHeader');
          httpWaitingBody         : DebugLog(loProtSpecInfo, 'State = httpWaitingBody');
          httpBodyReceived        : DebugLog(loProtSpecInfo, 'State = httpBodyReceived');
          httpWaitingProxyConnect : DebugLog(loProtSpecInfo, 'State = httpWaitingProxyConnect');
          httpClosing             : DebugLog(loProtSpecInfo, 'State = httpClosing');
          httpAborting            : DebugLog(loProtSpecInfo, 'State = httpAborting');
        else                        DebugLog(loProtSpecInfo, 'State = INVALID STATE');
        end;
    end;
{$ENDIF}
    if Assigned(FOnStateChange) then
        FOnStateChange(Self);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure THttpCli.TriggerCookie(const Data : String; var bAccept : Boolean);
begin
    if Assigned(FOnCookie) then
        FOnCookie(Self, Data, bAccept);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure THttpCli.TriggerSessionConnected;
begin
    if Assigned(FOnSessionConnected) then
        FOnSessionConnected(Self);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure THttpCli.TriggerSessionClosed;
begin
    if Assigned(FOnSessionClosed) then
        FOnSessionClosed(Self);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure THttpCli.TriggerDocBegin;
begin
{$IFNDEF NO_DEBUG_LOG}
    if CheckLogOptions(loProtSpecInfo) then  { V1.91 } { replaces $IFDEF DEBUG_OUTPUT  }
        DebugLog(loProtSpecInfo, 'DocBegin');
{$ENDIF}
    if Assigned(FOnDocBegin) then
        FOnDocBegin(Self);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure THttpCli.TriggerDocEnd;
begin
{$IFDEF UseContentCoding} {V7.19}
            FContentCodingHnd.Complete;
        {$IFNDEF NO_DEBUG_LOG}
            if CheckLogOptions(loProtSpecInfo) then begin
                if Assigned(FRcvdStream) and (FContentEncoding <> '') then begin
                    DebugLog(loProtSpecInfo, FContentEncoding +
                             ' content uncompressed from ' +
                             IntToStr(FContentLength) + ' bytes to ' +
                             IntToStr(FRcvdStream.Size) + ' bytes');
                end;
            end;
        {$ENDIF}
{$ENDIF}{$IFNDEF NO_DEBUG_LOG}
    if CheckLogOptions(loProtSpecInfo) then  { V1.91 } { replaces $IFDEF DEBUG_OUTPUT  }
        DebugLog(loProtSpecInfo, 'DocEnd');
{$ENDIF}
    if Assigned(FOnDocEnd) then
        FOnDocEnd(Self);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure THttpCli.TriggerDocData(
    Data : Pointer;
    Len : Integer);
begin
    if Assigned(FOnDocData) then
        FOnDocData(Self, Data, Len);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure THttpCli.TriggerSendBegin;
begin
    if Assigned(FOnSendBegin) then
        FOnSendBegin(Self);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure THttpCli.TriggerSendEnd;
begin
    if Assigned(FOnSendEnd) then
        FOnSendEnd(Self);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure THttpCli.TriggerSendData(
    Data : Pointer;
    Len  : Integer);
begin
    if Assigned(FOnSendData) then
        FOnSendData(Self, Data, Len);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure THttpCli.TriggerHeaderBegin;
begin
    FHeaderEndFlag := TRUE;
    if Assigned(FOnHeaderBegin) then
        FOnHeaderBegin(Self);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure THttpCli.TriggerHeaderEnd;
begin
    FHeaderEndFlag := FALSE;
    if Assigned(FOnHeaderEnd) then
        FOnHeaderEnd(Self);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ V8.71 JK called before header processing, so they can be changed or logged.}
procedure THttpCli.TriggerHeaderFieldData(var AHeaderField, AHeaderData: String);
begin
//  add your own code in overriden method, see OverbyteIcsWebSocketCli.pas
end;

{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure THttpCli.TriggerBeforeHeaderSend(
    const Method : String;
    Headers      : TStrings);
begin
    if Assigned(FOnBeforeHeaderSend) then
        FOnBeforeHeaderSend(Self, Method, Headers);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure THttpCli.TriggerRequestHeaderBegin;
begin
    if Assigned(FOnRequestHeaderBegin) then
        FOnRequestHeaderBegin(Self);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure THttpCli.TriggerRequestHeaderEnd;
begin
    if Assigned(FOnRequestHeaderEnd) then
        FOnRequestHeaderEnd(Self);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{$IFDEF UseNTLMAuthentication}
procedure THttpCli.ElaborateNTLMAuth;
begin
    { if you place this code in GetHeaderLineNext, not each time will be }
    { called ...                                                         }
    if (FAuthNTLMState = ntlmMsg3) and (FStatusCode <> 401) and (FStatusCode <> 407) then
        FAuthNTLMState := ntlmDone
    else if (FAuthNTLMState = ntlmDone) and (FStatusCode = 401) then
        FAuthNTLMState := ntlmNone;

    if (FProxyAuthNTLMState = ntlmMsg3) and (FStatusCode <> 407) then
        FProxyAuthNTLMState := ntlmDone
    else if (FProxyAuthNTLMState = ntlmDone) and (FStatusCode = 407) then begin
        { if we lost proxy authenticated line, most probaly we lost also }
        { the authenticated line of Proxy to HTTP server, so reset the   }
        { NTLM state of HTTP also to none                                }
        FProxyAuthNTLMState := ntlmNone;
        { FAuthNTLMState      := ntlmNone; }   { Removed by *ML* on May 02, 2005 }
    end;
end;
{$ENDIF}


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure THttpCli.ElaborateBasicAuth;
begin
    { if you place this code in GetHeaderLineNext, not each time will be }
    { called ...                                                         }
    if (FAuthBasicState = basicMsg1) and (FStatusCode <> 401) and (FStatusCode <> 407) then
        FAuthBasicState := basicDone
    else if (FAuthBasicState = basicDone) and (FStatusCode = 401) then
        FAuthBasicState := basicNone;

    if (FProxyAuthBasicState = basicMsg1) and (FStatusCode <> 407) then
        FProxyAuthBasicState := basicDone
    else if (FProxyAuthBasicState = basicDone) and (FStatusCode = 407) then begin
        { if we lost proxy authenticated line, most probaly we lost also }
        { the authenticated line of Proxy to HTTP server, so reset the   }
        { Basic state of HTTP also to none                                }
        FProxyAuthBasicState := basicNone;
        { FAuthBasicState      := basicNone; }   { Removed by *ML* on May 02, 2005 }
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{$IFDEF UseNTLMAuthentication}
function THttpCli.PrepareNTLMAuth(var FlgClean : Boolean) : Boolean;
var
//    TmpInt          : Integer;
    WAI: Integer;
begin
{$IFNDEF NO_DEBUG_LOG}                                                  { V1.91 }
    //THttpNTLMState   = (ntlmNone, ntlmMsg1, ntlmMsg2, ntlmMsg3, ntlmDone);
    if CheckLogOptions(loProtSpecDump) then begin
        DebugLog(loProtSpecDump, Format('PrepareNTLMAuth begin, FStatusCode = %d ' +
                                        'FProxyAuthNTLMState=%d FAuthNTLMState=%d',
                                        [FStatusCode, Ord(FProxyAuthNTLMState),
                                        Ord(FAuthNTLMState)]));
    end;
{$ENDIF}
    { this flag can tell if we proceed with OnRequestDone or will try    }
    { to authenticate                                                    }
    Result := FALSE;
    WAI := FindAuthType(httpAuthNtlm);   { V8.69 find authorisation information for type }
    if WAI < 0 then Exit;
    if (httpoNoNTLMAuth in FOptions) and
       (((FStatusCode = 401) and (FServerAuth = httpAuthNtlm)) or
       ((FStatusCode = 407) and (FProxyAuth = httpAuthNtlm))) then
          Exit;

    if (FStatusCode = 401) and {(FDoAuthor.Count > 0) and }       { V8.69 was 407, got broken in V8.61 }
            (FProxyAuthBasicState = basicNone)
{$IFDEF UseDigestAuthentication}
            and (FProxyAuthDigestState = digestNone)
{$ENDIF}
            then begin  // V8.61  OAS : remove case where user and PW are empty because used for User credentials

        { We can handle authorization }
 {       TmpInt := FDoAuthor.Count - 1;
        while TmpInt >= 0  do begin
            if CompareText(Copy(FDoAuthor.Strings[TmpInt], 1, 4), 'NTLM') = 0 then begin
                Result := TRUE;
                if Assigned(FOnBeforeAuth) then
                    FOnBeforeAuth(Self, httpAuthNtlm, FALSE,
                                  FDoAuthor.Strings[TmpInt], Result);
                if Result then begin
                    if (FProxyUsername = '') and (FProxyPassword = '')  and not Assigned(FAuthNtlmSession) then  // V8.61
                        FAuthNtlmSession := TNtlmAuthSession.Create (cuOutbound) ;                               // Create session for proxy NTLM
                    StartAuthNTLM;
                    if FAuthNTLMState in [ntlmMsg1, ntlmMsg3] then
                        FlgClean := True;
                    Break;
                end;
            end;
            Dec(TmpInt);
        end;  }

     { V8.69 use parsed headers from WWWAuthInfos instead of enumerating FDoAuthor.Strings }
        Result := TRUE;
        if Assigned(FOnBeforeAuth) then
            FOnBeforeAuth(Self, httpAuthNtlm, FALSE, WWWAuthInfos[WAI].Header, Result);
        if Result then begin
            if (FProxyUsername = '') and (FProxyPassword = '')  and not Assigned(FAuthNtlmSession) then  // V8.61
                FAuthNtlmSession := TNtlmAuthSession.Create (cuOutbound) ;                               // Create session for proxy NTLM
            StartAuthNTLM;
            if FAuthNTLMState in [ntlmMsg1, ntlmMsg3] then
                FlgClean := True;
        end;
    end
    else if (FStatusCode = 407) and { (FDoAuthor.Count > 0) and  }
            (FProxyAuthBasicState = basicNone) and
{$IFDEF UseDigestAuthentication}
            (FProxyAuthDigestState = digestNone) and
{$ENDIF}
            (FProxyUsername <> '') and (FProxyPassword <> '') then begin
        {BLD proxy NTLM authentication}
        { We can handle authorization }
{        TmpInt := FDoAuthor.Count - 1;
        while TmpInt >= 0  do begin
            if CompareText(Copy(FDoAuthor.Strings[TmpInt], 1, 4), 'NTLM') = 0 then begin
                Result := TRUE;
                if Assigned(FOnBeforeAuth) then
                    FOnBeforeAuth(Self, httpAuthNtlm, TRUE,
                                  FDoAuthor.Strings[TmpInt], Result);
                if Result then begin
                    StartProxyAuthNTLM;
                    if FProxyAuthNTLMState in [ntlmMsg1, ntlmMsg3] then
                        FlgClean := True;

                    Break;
                end;
            end;
            Dec(TmpInt);
        end;   }

     { V8.69 use parsed headers from WWWAuthInfos instead of enumerating FDoAuthor.Strings }
        Result := TRUE;
        if Assigned(FOnBeforeAuth) then
            FOnBeforeAuth(Self, httpAuthNtlm, FALSE, WWWAuthInfos[WAI].Header, Result);
        if Result then begin
            StartProxyAuthNTLM;
            if FProxyAuthNTLMState in [ntlmMsg1, ntlmMsg3] then
                FlgClean := True;
        end;
    end;
{$IFNDEF NO_DEBUG_LOG}                                                 { V1.91 }
    //THttpNTLMState   = (ntlmNone, ntlmMsg1, ntlmMsg2, ntlmMsg3, ntlmDone);
    if CheckLogOptions(loProtSpecDump) then begin
        DebugLog(loProtSpecDump, Format('PrepareNTLMAuth end, FStatusCode = %d ' +
                                        'FProxyAuthNTLMState=%d FAuthNTLMState=%d',
                                        [FStatusCode, Ord(FProxyAuthNTLMState),
                                        Ord(FAuthNTLMState)]));
    end;
{$ENDIF}
end;
{$ENDIF}


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function THttpCli.PrepareBasicAuth(var FlgClean : Boolean) : Boolean;
var
//    TmpInt          : Integer;
    WAI: Integer;
begin
    { this flag can tell if we proceed with OnRequestDone or will try    }
    { to authenticate                                                    }
    Result := FALSE;
    WAI := FindAuthType(httpAuthBasic);   { V8.69 find authorisation information }
    if WAI < 0 then Exit;
    if (httpoNoBasicAuth in FOptions) and
       (((FStatusCode = 401) and (FServerAuth = httpAuthBasic)) or
       ((FStatusCode = 407) and (FProxyAuth = httpAuthBasic))) then
        Exit;

    if (FStatusCode = 401) and { (FDoAuthor.Count > 0) and }
{$IFDEF UseNTLMAuthentication}
       (FAuthNTLMState = ntlmNone) and
{$ENDIF}
{$IFDEF UseDigestAuthentication}
       (FAuthDigestState = digestNone) and
{$ENDIF}
       (FCurrUserName <> '') and (FCurrPassword <> '') then begin
        { We can handle authorization }
    {    TmpInt := FDoAuthor.Count - 1;
        while TmpInt >= 0  do begin
            if CompareText(Copy(FDoAuthor.Strings[TmpInt], 1, 5),
                           'Basic') = 0 then begin
                Result := TRUE;
                if Assigned(FOnBeforeAuth) then
                    FOnBeforeAuth(Self, httpAuthBasic, TRUE,
                                  FDoAuthor.Strings[TmpInt], Result);
                if Result then begin
                    StartAuthBasic;
                    if FAuthBasicState in [basicMsg1] then
                        FlgClean := True;

                    Break;
                end;
            end;
            Dec(TmpInt);
        end;   }

     { V8.69 used parsed headers from WWWAuthInfos instead of enumerating FDoAuthor.Strings }
        Result := TRUE;
        if Assigned(FOnBeforeAuth) then
            FOnBeforeAuth(Self, httpAuthBasic, TRUE, WWWAuthInfos[WAI].Header, Result);
        if Result then begin
            StartAuthBasic;
            if FAuthBasicState in [basicMsg1] then
                FlgClean := True;
        end;
    end
    else if (FStatusCode = 407) and { (FDoAuthor.Count > 0) and  }
{$IFDEF UseNTLMAuthentication}
        (FProxyAuthNTLMState = ntlmNone) and
{$ENDIF}
{$IFDEF UseDigestAuthentication}
        (FProxyAuthDigestState = digestNone) and
{$ENDIF}
        (FProxyUsername <> '') and (FProxyPassword <> '') then begin
        { We can handle authorization }
     {   TmpInt := FDoAuthor.Count - 1;
        while TmpInt >= 0  do begin
            if CompareText(Copy(FDoAuthor.Strings[TmpInt], 1, 5),
                           'Basic') = 0 then begin
                Result := TRUE;
                if Assigned(FOnBeforeAuth) then
                    FOnBeforeAuth(Self, httpAuthBasic, TRUE,
                                  FDoAuthor.Strings[TmpInt], Result);
                if Result then begin
                    StartProxyAuthBasic;
                    if FProxyAuthBasicState in [basicMsg1] then
                        FlgClean := True;

                    Break;
                end;
            end;
            Dec(TmpInt);
        end;       }

     { V8.69 used parsed headers from WWWAuthInfos instead of enumerating FDoAuthor.Strings }
        Result := TRUE;
        if Assigned(FOnBeforeAuth) then
            FOnBeforeAuth(Self, httpAuthBasic, TRUE, WWWAuthInfos[WAI].Header, Result);
        if Result then begin
            StartProxyAuthBasic;
            if FProxyAuthBasicState in [basicMsg1] then
                FlgClean := True;
        end;
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure THttpCli.TriggerRequestDone;
begin
    PostMessage(Handle, FMsg_WM_HTTP_REQUEST_DONE, 0, 0);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure THttpCli.TriggerRequestDone2;  { V8.61 so we can override it }
begin
{$IFNDEF NO_DEBUG_LOG}
    if CheckLogOptions(loProtSpecInfo) then  { V1.91 } { replaces $IFDEF DEBUG_OUTPUT  }
            DebugLog(loProtSpecInfo, 'RequestDone');
{$ENDIF}
    if Assigned(FOnRequestDone) then
        FOnRequestDone(Self, FRequestType, FRequestDoneError);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure THttpCli.WMHttpRequestDone(var msg: TMessage);
begin
   TriggerRequestDone2;  { V8.61 }
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure THttpCli.TriggerCommand(var S: String);  { V8.61 }
begin
    if Assigned(FOnCommand) then
        FOnCommand(Self, S);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure THttpCli.TriggerHeaderData;   { V8.61 }
begin
    if Assigned(FOnHeaderData) then
        FOnHeaderData(Self);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure THttpCli.TriggerLocationChange;  { V8.61 }
begin
    if Assigned(FOnLocationChange) then
         FOnLocationChange(Self);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure THttpCli.WMHttpSetReady(var msg: TMessage);
begin
    StateChange(httpReady);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure ReplaceExt(var FName : String; const newExt : String);
var
    I : Integer;
begin
    I := Posn('.', FName, -1);
    if I <= 0 then
        FName := FName + '.' + newExt
    else
        FName := Copy(FName, 1, I) + newExt;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure THttpCli.Abort;
var
    bFlag : Boolean;
    Msg   : TMessage;
begin
    FLocationFlag := FALSE;  { Do not follow relocations V7.10 }
    { The following two lines prevent OnRequestDone from trigger twice V7.10 }
    FRcvdCount    := 0;      { Clear the receive buffer V7.10 }
    FReceiveLen   := 0;      { Clear the receive buffer V7.10 }

    if FState = httpReady then begin
        FState := httpAborting;
        if FCtrlSocket.State <> wsClosed then begin
            FReasonPhrase := 'Not Closed While Ready, Aborted' ;    { V8.68 }
            FCtrlSocket.Abort;
        end;
        FReasonPhrase := 'OK' ;
        FStatusCode       := 200;
        FRequestDoneError := httperrNoError;
        FState            := httpReady;
        TriggerStateChange;
        WMHttpRequestDone(Msg);   { Synchronous operation ! }
        Exit;
    end;

    bFlag := (FState = httpDnsLookup);
    StateChange(httpAborting);

    if bFlag then begin
        try
            FCtrlSocket.CancelDnsLookup;
        except
            { Ignore any exception }
        end;
    end;

    FStatusCode       := 404;
    if FReasonPhrase = '' then  { V8.55 may have SSL handshake error }
        FReasonPhrase := 'Connection aborted on request';

  { V8.65 may have RequestDoneError already }
    if FRequestDoneError = httperrNoError then
        FRequestDoneError := httperrAborted;

    if bFlag then
        SocketSessionClosed(Self, 0)
    else
        FCtrlSocket.Close;
    StateChange(httpReady);  { 13/02/99 }
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure THttpCli.AbortComponent(E:Exception);    { V8.68 added E to allow reporting }
begin
    try
  { V8.65 try and provide better RequestDoneError than simple abort }
        FReasonPhrase := 'Abort on Exception: ' + IcsGetExceptMess(E);    { V8.68 }
        if E.ClassType = EOutOfMemory then
            FRequestDoneError := httperrOutOfMemory
        else
            FRequestDoneError := httperrBgException;
        Abort;
    except
    end;
    inherited;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure THttpCli.Login;
begin
{$IFNDEF NO_DEBUG_LOG}
    if CheckLogOptions(loProtSpecInfo) then  { V1.91 } { replaces $IFDEF DEBUG_OUTPUT  }
            DebugLog(loProtSpecInfo, 'Login ' + FHostName);
{$ENDIF}
    FWMLoginQueued := FALSE;
    FStatusCode    := 0;
    FLocationFlag  := False;
    FReasonPhrase  := '';  { V8.55 }

    FCtrlSocket.OnSessionClosed := SocketSessionClosed;

    if FCtrlSocket.State = wsConnected then begin
        SocketSessionConnected(nil, 0);
        Exit;
    end;

    FDnsResult := '';
    FPunyCodeHost := '';  { V8.65 }
    StateChange(httpDnsLookup);
    FCtrlSocket.LocalAddr := FLocalAddr; {bb}
    FCtrlSocket.LocalAddr6 := FLocalAddr6;  { V8.02 }
    FCtrlSocket.SocketErrs := FSocketErrs;        { V8.37 }
    try
        FCtrlSocket.SocketFamily := FSocketFamily;
        { The setter of TCustomWSocket.Addr sets the correct internal     }
        { SocketFamily in case a host name is either a valid IPv6 or IPv4 }
        { address.                                                        }
        FCtrlSocket.Addr := FHostName;   { Unicode}
        if (FSocksServer = '') or (FSocksLevel = '4') then  { V8.51 socks5 takes host name }
            FCtrlSocket.DnsLookup(FHostName)  { Unicode}
        else
            SocketDNSLookupDone(self, 0);    { V8.51 skip DNS lookup }
    except
        on E: Exception do begin
            FStatusCode   := 404;
            FReasonPhrase := E.Message;
            FConnected    := FALSE;
            StateChange(httpReady);
        end;
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure THttpCli.DoBeforeConnect;
begin
    FCtrlSocket.Addr                := FDnsResult; { V8.51 for SOCKS5 may be host name }
    FCtrlSocket.LocalAddr           := FLocalAddr; {bb}
    FCtrlSocket.LocalAddr6          := FLocalAddr6;  { V8.02 }
    FCtrlSocket.Port                := FPort;
    FCtrlSocket.Proto               := 'tcp';
    FCtrlSocket.SocksServer         := FSocksServer;
    if FSocksLevel <> '' then                        { V8.37 don't set blank }
        FCtrlSocket.SocksLevel      := FSocksLevel;
    FCtrlSocket.SocksPort           := FSocksPort;
    FCtrlSocket.SocksUsercode       := FSocksUsercode;
    FCtrlSocket.SocksPassword       := FSocksPassword;
    FCtrlSocket.SocksAuthentication := FSocksAuthentication;
    FCtrlSocket.SocketErrs          := FSocketErrs;        { V8.37 }
    FReceiveLen                     := 0; { Clear the receive buffer V7.10 }
{$IFDEF BUILTIN_THROTTLE}
    if httpoBandwidthControl in FOptions then begin
        FCtrlSocket.BandwidthLimit     := FBandwidthLimit;
        FCtrlSocket.BandwidthSampling  := FBandwidthSampling;
    end
    else
        FCtrlSocket.BandwidthLimit := 0;
{$ENDIF}
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure THttpCli.SocketDNSLookupDone(Sender: TObject; ErrCode: Word);
var
    I: Integer;
begin
{$IFNDEF NO_DEBUG_LOG}
    if CheckLogOptions(loProtSpecInfo) then
        DebugLog(loProtSpecInfo, 'Socket DNS Lookup Done - '  +
                                FCtrlSocket.DnsResultList.CommaText);  { V8.60 }
{$ENDIF}
    {if FPunyCodeHost = '' then}        // only first connection
    FPunyCodeHost := FCtrlSocket.PunyCodeHost;   { V8.65 each new lookup }
    if ErrCode <> 0 then begin
        if FState = httpAborting then
            Exit;
        FRequestDoneError := ErrCode;
        FStatusCode       := 404;
        FReasonPhrase     := 'can''t resolve hostname to IP address';
        SocketSessionClosed(Sender, ErrCode);
    end
    else begin
        if (FSocksServer = '') or (FSocksLevel = '4') then begin  { V8.51 socks5 takes host name }

        { V8.57 allow application to change DnsResult to one of the several offered, round robin or IPV4/IPV6 }
            if Assigned(FOnSelectDns) then begin
                FDnsResult := FCtrlSocket.DnsResult;
                FOnSelectDns(Self, FCtrlSocket.DnsResultList, FDnsResult);
            end
            else begin

              { V8.60 DNS lookup may return multiple IP addrese, round robin through
                them trying each on multiple retries.  Addresses taken consecutively
                from DnsResultList unless FLastAddrOK has been set on a successful
                connect, when it will re-used for the next attempt if still in
                DnsResultList.  Loop to start again when all addresses tried.  }

                FTotDnsResult := FCtrlSocket.DnsResultList.Count;
                if (FTotDnsResult <= 0) then Exit;  { sanity check }

              { single DNS result, nothing more to do }
                if (FTotDnsResult = 1) then
                    FDnsResult := FCtrlSocket.DnsResult
                else begin
                  { if last succesaful IP address in list of results, use it again }
                    FDnsResult := '';
                    if (FLastAddrOK <> '') then begin
                        for I := 0 to FTotDnsResult - 1 do begin
                            if FLastAddrOK = FCtrlSocket.DnsResultList[I] then begin
                                FCurrDnsResult := I;
                                FDnsResult := FLastAddrOK;
        {$IFNDEF NO_DEBUG_LOG}
                                if CheckLogOptions(loProtSpecInfo) then
                                    DebugLog(loProtSpecInfo, 'Reusing Last OK Address: ' + FLastAddrOK);
        {$ENDIF}
                                break;
                            end;
                        end;
                    end;

                  { not found it, find next, loop to start if gone past last }
                    if FDnsResult = '' then begin
                        inc (FCurrDnsResult);
                        if (FCurrDnsResult >= FTotDnsResult) then
                            FCurrDnsResult := 0;
                        FDnsResult := FCtrlSocket.DnsResultList[FCurrDnsResult];
        {$IFNDEF NO_DEBUG_LOG}
                        if CheckLogOptions(loProtSpecInfo) then
                            DebugLog(loProtSpecInfo, 'Alternate Address: ' + FDnsResult);
        {$ENDIF}
                    end;
                end;
            end;
        end
        else
            FDnsResult := FHostName;
        StateChange(httpDnsLookupDone);  { 19/09/98 }
        DoBeforeConnect;
        FCurrentHost          := FHostName;
        FCurrentPort          := FPort;
        FCurrentProtocol      := FProtocol;
{$IFDEF USE_SSL}
        FCtrlSocket.SslEnable := ((FProxy = '') and IsSSLProtocol(FProtocol));    { V8.71 JK }
     { V8.71 earlier check that OpenSSL is loaded }
        if FCtrlSocket.SslEnable then begin
             if NOT FCtrlSocket.SslContext.IsSslInitialized then
                FCtrlSocket.SslContext.InitializeSsl;
        end;
{$ENDIF}
        if NOT IsKnownProtocol(FProtocol) then begin                               { V8.71 JK }
            FRequestDoneError := FCtrlSocket.LastError;
            FStatusCode       := 501;
            FReasonPhrase     := 'Protocol "' + FProtocol + '" not implemented';
            FCtrlSocket.Close;
            SocketSessionClosed(Sender, FCtrlSocket.LastError);
            Exit;
        end;
{ 05/02/2005 end }
    {$IFNDEF NO_DEBUG_LOG}
        if CheckLogOptions(loProtSpecInfo) then  { V1.91 } { replaces $IFDEF DEBUG_OUTPUT  }
            DebugLog(loProtSpecInfo, 'connect to ' + FDnsResult + '/' + FPort);
{$ENDIF}
        try
            FCtrlSocket.Connect;
        except
            FRequestDoneError := FCtrlSocket.LastError;
            FStatusCode       := 404;
            FReasonPhrase     := 'can''t connect: ' +
                                 WSocketErrorMsgFromErrorCode(FCtrlSocket.LastError) +  { V8.51 handles proxy errors }
                              {   WSocketErrorDesc(FCtrlSocket.LastError) +  }
                                 ' (Error #' + IntToStr(FCtrlSocket.LastError) + ')';
            FCtrlSocket.Close;
            SocketSessionClosed(Sender, FCtrlSocket.LastError);
        end;
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure THttpCli.SocketSessionConnected(Sender : TObject; ErrCode : Word);

    procedure InitStartSend;      { V8.71 commonize code }
    begin
    {$IFDEF UseNTLMAuthentication}
        if not ((FAuthNTLMState = ntlmMsg1) or (FProxyAuthNTLMState = ntlmMsg1)) then begin
            TriggerSendBegin;
            FAllowedToSend := TRUE;
            FDelaySetReady := FALSE;     { 09/26/08 ML }
            SocketDataSent(FCtrlSocket, 0);
        end;
    {$ELSE}
        TriggerSendBegin;
        FAllowedToSend := TRUE;
        FDelaySetReady := FALSE;     { 09/26/08 ML }
        SocketDataSent(FCtrlSocket, 0);
    {$ENDIF}
    end;

begin
    FAddrResolvedStr := FCtrlSocket.AddrResolvedStr; { V8.66 keep it before socket closes }

{$IFNDEF NO_DEBUG_LOG}
    if CheckLogOptions(loProtSpecInfo) then  { V1.91 }
        DebugLog(loProtSpecInfo, 'SessionConnected, error='  + IntToStr (ErrCode) + ' to ' + IcsFmtIpv6AddrPort(FAddrResolvedStr, FPort));  { V8.60 }
{$ENDIF}
    if ErrCode <> 0 then begin
        FRequestDoneError := ErrCode;
        FStatusCode := 404;
        FReasonPhrase := WSocketErrorMsgFromErrorCode(ErrCode) +  { V8.51 handles proxy errors }
                          ' (Error #' + IntToStr(ErrCode) + ') to ' + IcsFmtIpv6AddrPort(FAddrResolvedStr, FPort);  { V8.60 }
        FLastAddrOK := '';  { V8.60 }
        TriggerSessionConnected; {14/12/2003}
        Exit;
    end;

    FLocationFlag := FALSE;

    FConnected := TRUE;
    FLastAddrOK := FAddrResolvedStr;  { V8.60 }
    StateChange(httpConnected);
    TriggerSessionConnected;

    FNext := GetHeaderLineNext;
    try
        if (FProxy <> '') and IsSSLProtocol(FProtocol) and  ((FProxyConnected = FALSE) or  { V8.71 JK }
    {$IFDEF UseNTLMAuthentication}
           (FProxyConnected and (FProxyAuthNTLMState = ntlmMsg3)) or (FProxyConnected and (FProxyAuthNTLMState = ntlmMsg1)) or // <= AG 12/27/05
        {$IFDEF UseDigestAuthentication}
           (FProxyConnected and (FProxyAuthDigestState = digestMsg1)) or
        {$ENDIF}
           (FProxyConnected and (FProxyAuthBasicState = basicMsg1)))
    {$ELSE}
        {$IFDEF UseDigestAuthentication}
           (FProxyConnected and (FProxyAuthDigestState = digestMsg1)) or
        {$ENDIF}
           (FProxyConnected and (FProxyAuthBasicState = basicMsg1)))
    {$ENDIF}
        then begin
            StateChange(httpWaitingProxyConnect);
            FReqStream.Clear;
            if (FRequestVer = '1.0') or (FResponseVer = '1.0') or (FResponseVer = '') then
                FCurrProxyConnection := 'Keep-Alive';
            SendRequest('CONNECT', FRequestVer{'1.0'});
        end
        else begin
            StateChange(httpWaitingHeader);

            case FRequestType of
            httpPOST:
                begin
                    SendRequest('POST', FRequestVer);
                    InitStartSend;                    { V8.71 commonize code }
                end;
            httpPUT:
                begin
                    SendRequest('PUT', FRequestVer);
                    InitStartSend;                    { V8.71 commonize code }
                end;
            httpPATCH:  { V8.06 }
                begin
                    SendRequest('PATCH', FRequestVer);
                    InitStartSend;                    { V8.71 commonize code }
                end;
            httpDELETE:
                begin
                    SendRequest('DELETE', FRequestVer);
                 { V8.71 DELETE can have a content body }
                    if (httpoGetContent in FOptions) and Assigned(SendStream) then
                      InitStartSend;                    { V8.71 commonize code }
                end;
            httpOPTIONS:
                begin
                    SendRequest('OPTIONS', FRequestVer);
                end;
            httpTRACE:
                begin
                    SendRequest('TRACE', FRequestVer);
                end;
            httpHEAD:
                begin
                    SendRequest('HEAD', FRequestVer);
                end;
            httpGET:
                begin
                    SendRequest('GET', FRequestVer);
                 { V8.71 GET can have a content body }
                 { beware SendStream should be nil if there is no content }
                    if (httpoGetContent in FOptions) and Assigned(SendStream) then
                      InitStartSend;                    { V8.71 commonize code }
                end;
            end;
        end;
    except
        Logout;
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure THttpCli.Logout;
begin
    FCtrlSocket.Close;
    FConnected := FALSE;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure THttpCli.SendCommand(const Cmd : String);
const
    CRLF : String[2] = #13#10;
var
    Buf : String;
begin
    Buf := Cmd;
    TriggerCommand(Buf);  { V8.61 }
    if Length(Buf) > 0 then
    {$IFDEF COMPILER12_UP}
        StreamWriteString(FReqStream, Buf, CP_ACP);
    {$ELSE}
        FReqStream.Write(Buf[1], Length(Buf));
    {$ENDIF}
    FReqStream.Write(CRLF[1], 2);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure THttpCli.SendRequest(const Method, Version: String);
var
    Headers : TStrings;
    N       : Integer;
    AHost   : String;
begin
    Headers := TStringList.Create;
    try
        FReqStream.Clear;
        TriggerRequestHeaderBegin;
     { V8.64 needs A-Label punycode for Host: not Unicode }
        AHost := IcsIDNAToASCII(IcsTrim(FTargetHost));
        if Method = 'CONNECT' then
            Headers.Add(Method + ' ' + AHost + ':' + FTargetPort + ' HTTP/' + Version)  { V8.64 A-Label }
        else begin
            Headers.Add(Method + ' ' + FPath + ' HTTP/' + Version);
            if FSender <> '' then
                Headers.Add('From: ' + FSender);
            if FAccept <> '' then
                Headers.Add('Accept: ' + FAccept);
            if FReference <> '' then
                Headers.Add('Referer: ' + FReference);
            if FCurrConnection <> '' then
                Headers.Add('Connection: ' + FCurrConnection);
            if FAcceptLanguage <> '' then
                Headers.Add('Accept-Language: ' + FAcceptLanguage);
        {$IFDEF UseContentCoding}
            if (FContentCodingHnd.HeaderText <> '') and (FRequestType <> httpHEAD) then
                Headers.Add('Accept-Encoding: ' + FContentCodingHnd.HeaderText);
        {$ENDIF}
            if (FRequestType in [httpPOST, httpPUT, httpPATCH]) or
                 { V8.71 DELETE and GET can also have body }
                    ((httpoGetContent in FOptions) and (FRequestType in [httpDELETE, httpGET])) then begin
                if (FContentPost <> '') then
                    Headers.Add('Content-Type: ' + FContentPost);
            end;
        end;
        if FAgent <> '' then
            Headers.Add('User-Agent: ' + FAgent);
        if (FTargetPort = '80') or (FTargetPort = '443') or (FTargetPort = '') then { V8.05 }
            Headers.Add('Host: ' + AHost)    { V8.64 A-Label }
        else
            Headers.Add('Host: ' + AHost + ':' + FTargetPort);   { V8.64 A-Label }
        if FNoCache then begin
            if Version = '1.0' then
                Headers.Add('Pragma: no-cache')
            else
                Headers.Add('Cache-Control: no-cache');  { V8.61 }
        end;
        if FCurrProxyConnection <> '' then
            Headers.Add('Proxy-Connection: ' + FCurrProxyConnection);
        if (Method = 'CONNECT') then                                   // <= 12/29/05 AG
            Headers.Add('Content-Length: 0')                           // <= 12/29/05 AG}
        else begin  { V7.05 begin }
            if (FRequestType in [httpPOST, httpPUT, httpPATCH]) or
              { V8.71 DELETE and GET can also have body }
                 ((httpoGetContent in FOptions) and (FRequestType in [httpDELETE, httpGET])) then begin
               if Assigned(SendStream) then begin  { V8.71 Always check if SendStream exists before accessing it }
                    {$IFDEF UseNTLMAuthentication}
                    if (FAuthNTLMState = ntlmMsg1) or(FProxyAuthNTLMState = ntlmMsg1) then
                        Headers.Add('Content-Length: 0')
                    else
                   {$ENDIF}
                        Headers.Add('Content-Length: ' + IntToStr(SendStream.Size - SendStream.Position));
              end;
            end;
        end; { V7.05 end }
        if FModifiedSince <> 0 then
            Headers.Add('If-Modified-Since: ' + RFC1123_Date(FModifiedSince) + ' GMT');

    // IfMatch need one or more quoted Etags, ie "<etag_value>", "<etag_value>"
        if FReqIfMatch <> '' then
            Headers.Add('If-Match: ' + FReqIfMatch);            { V8.68 }
        if FReqIfNoneMatch <> '' then
            Headers.Add('If-None-Match: ' + FReqIfNoneMatch);    { V8.68 }

        if not FProxyConnected then begin
            { We did not call SetReady while in relocation, adjust }
            { ProxyAuthNtlmState if we got disconnected from proxy }
          {$IFDEF UseNTLMAuthentication}
            if FProxyAuthNtlmState = ntlmDone then
                FProxyAuthNtlmState := ntlmMsg1;
          {$ENDIF}
        end;

      { V8.54 add OAuth header, Bearer is the official way, X-Auth-Token unofficial }
        if (FServerAuth = httpAuthBearer) and (FAuthBearerToken <> '') then
            Headers.Add('Authorization: Bearer ' + FAuthBearerToken);
        if (FServerAuth = httpAuthToken) and (FAuthBearerToken <> '') then
            Headers.Add('X-Auth-Token: ' + FAuthBearerToken);
        if (FServerAuth = httpAuthJWT) and (FAuthBearerToken <> '') then   { V8.62 }
            Headers.Add('Authorization: JWT ' + FAuthBearerToken);
        if (FServerAuth = httpAuthOAuth) and (FAuthBearerToken <> '') then { V8.65 }
            Headers.Add('Authorization: OAuth ' + FAuthBearerToken);

{$IFDEF UseNTLMAuthentication}
        if (FProxyAuthNTLMState <> ntlmMsg1) then begin
            if (FAuthNTLMState = ntlmMsg1) then
                Headers.Add(GetNTLMMessage1(FALSE))
            else if (FAuthNTLMState = ntlmMsg3) then
                Headers.Add(GetNTLMMessage3(Method, FALSE))
    {$IFDEF UseDigestAuthentication}
            else if (FAuthDigestState = digestMsg1) then
                Headers.Add(GetDigestAuthorizationHeader(Method, FALSE))
    {$ENDIF}
            else if (FAuthBasicState = basicMsg1) then
                Headers.Add(GetBasicAuthorizationHeader(Method, FALSE))
            else begin
                // Maybe an event to add a preemptive Authorization header?
            end;
        end;
{$ELSE}
    {$IFDEF UseDigestAuthentication}
        if (FAuthDigestState = digestMsg1) then
            Headers.Add(GetDigestAuthorizationHeader(Method, FALSE))
        else
    {$ENDIF}
        if (FAuthBasicState = basicMsg1) then
            Headers.Add(GetBasicAuthorizationHeader(Method, FALSE))
        else begin
            // Maybe an event to add a preemptive Authorization header?
        end;
{$ENDIF}
    {$IFDEF UseNTLMAuthentication}
        if (FProxyAuthNTLMState = ntlmMsg1) then
            Headers.Add(GetNTLMMessage1(TRUE))
        else if (FProxyAuthNTLMState = ntlmMsg3) then
            Headers.Add(GetNTLMMessage3(Method, TRUE))
        else
    {$ENDIF}
    {$IFDEF UseDigestAuthentication}
        if (FProxyAuthDigestState = digestMsg1) then
            Headers.Add(GetDigestAuthorizationHeader(Method, TRUE))
        else
    {$ENDIF}
        if (FProxyAuthBasicState = basicMsg1) then
           Headers.Add(GetBasicAuthorizationHeader(Method, TRUE))
        else if Length(FProxy) > 0 then begin
            // Maybe an event to add a preemptive Authorization header?
        end;

        if FCookie <> '' then
            Headers.Add('Cookie: ' + FCookie);
        if (FContentRangeBegin <> '') or (FContentRangeEnd <> '') then begin            {JMR!! Added this line!!!}
            Headers.Add('Range: bytes=' + FContentRangeBegin + '-' + FContentRangeEnd); {JMR!! Added this line!!!}
            if (FContentIfRange <> '') then                                             { V8.68 make range conditional }
                Headers.Add('If-Range: ' + FContentIfRange);                            { last modified date or etag }
            if (Method <> 'CONNECT') then { V7.21 }
            begin
                FContentRangeBegin := '';                                               {JMR!! Added this line!!!}
                FContentRangeEnd   := '';                                               {JMR!! Added this line!!!}
            end;
        end;                                                                            {JMR!! Added this line!!!}
        FAcceptRanges := '';

      { V8.52 add extra headers, ignore any without colon }
        if FExtraHeaders.Count > 0 then begin
            for N := 0 to FExtraHeaders.Count - 1 do begin
                if Pos (': ', FExtraHeaders[N]) > 1 then
                    Headers.Add(FExtraHeaders[N]);
            end;
        end;

        TriggerBeforeHeaderSend(Method, Headers);
        for N := 0 to Headers.Count - 1 do
            SendCommand(Headers[N]);
        TriggerRequestHeaderEnd;
    {$IFNDEF NO_DEBUG_LOG}    { V8.13 ensure headers added in event are logged }
        if CheckLogOptions(loProtSpecInfo) then  { V1.91 } { replaces $IFDEF DEBUG_OUTPUT  }
            DebugLog(loProtSpecInfo, IntToStr(Headers.Count) + ' header lines to send'#13#10 + Headers.Text);
    {$ENDIF}
        SendCommand('');
        FCtrlSocket.PutDataInSendBuffer(FReqStream.Memory, FReqStream.Size);
        FReqStream.Clear;

     { V8.71 try to prevent the header and content from being sent as separate TCP packets which may confuse some
            middleware, if body is empty then it will be sent now otherwise when stream is sent }
        if NOT(Assigned(FSendStream)) or (FSendStream.Size = 0) then
            FCtrlSocket.Send(nil, 0);
    finally
        Headers.Free;
    {$IFNDEF NO_DEBUG_LOG}
        if CheckLogOptions(loProtSpecInfo) then  { V1.91 } { replaces $IFDEF DEBUG_OUTPUT  }
            DebugLog(loProtSpecInfo, 'SendRequest Done');
    {$ENDIF}
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ Data is pointed by FBodyData and FBodyDataLen as length                   }
procedure THttpCli.GetBodyLineNext;
var
//  P    : PChar;
    P    : Integer; // (FP 09/09/06)
    N, K : THttpBigInt;
begin
{$IFNDEF NO_DEBUG_LOG}
    if CheckLogOptions(loProtSpecInfo) then  { V1.91 } { replaces $IFDEF DEBUG_OUTPUT  }
        DebugLog(loProtSpecInfo, 'GetBodyLineNext begin');
{$ENDIF}
    if NOT FBodyStartedFlag then begin   { V8.67 was FBodyLineCount }
        FBodyStartedFlag := True;
        FChunkLength := 0;
        FChunkRcvd   := 0;
        FChunkState  := httpChunkGetSize;
        TriggerDocBegin;
{$IFDEF UseContentCoding}
        FContentCodingHnd.Prepare(FContentEncoding);
        if Assigned(FRcvdStream) then
            FRcvdStreamStartSize := FRcvdStream.Size
        else
            FRcvdStreamStartSize := 0;
{$ENDIF}
    end;
{$IFNDEF NO_DEBUG_LOG}
    if CheckLogOptions(loProtSpecInfo) then  { V1.91 } { replaces $IFDEF DEBUG_OUTPUT  }
        DebugLog(loProtSpecInfo, 'GetBodyLineNext FBodyDataLen=' + IntToStr(FBodyDataLen));
{$ENDIF}
    if FTransferEncoding = 'chunked' then begin
// RFC-2616 3.6.1 Chunked Transfer Coding
//      Chunked-Body    = *chunk
//                        last-chunk
//                        trailer
//                        CRLF
//
//      chunk           = chunk-size [ chunk-extension ] CRLF
//                        chunk-data CRLF
//      chunk-size      = 1*HEX
//      last-chunk      = 1*("0") [ chunk-extension ] CRLF
//
//      chunk-extension = *( ";" chunk-ext-name [ "=" chunk-ext-val ] )
//      chunk-ext-name  = token
//      chunk-ext-val   = token | quoted-string
//      chunk-data      = chunk-size(OCTET)
//      trailer         = *(entity-header CRLF)
        P := FBodyData;
        N := FBodyDataLen;
        while (N > 0) and (FChunkState <> httpChunkDone) do begin
            if FChunkState = httpChunkGetSize then begin
                while N > 0 do begin
//                  if not IsXDigit(P^) then begin
                    if not IsXDigit(AnsiChar(FReceiveBuffer[P])) then begin  // (FP 09/09/06)
                        FChunkState := httpChunkGetExt;
                        {$IFNDEF NO_DEBUG_LOG}
                        if CheckLogOptions(loProtSpecInfo) then  { V1.91 } { replaces $IFDEF DEBUG_OUTPUT  }
                            DebugLog(loProtSpecInfo, 'ChunkLength = ' + IntToStr(FChunkLength));
                        {$ENDIF}
                        break;
                    end;
//                  FChunkLength := FChunkLength * 16 + XDigit(P^);
                    FChunkLength := FChunkLength * 16 + XDigit(AnsiChar(FReceiveBuffer[P]));  // (FP 09/09/06)
                    Inc(P);
                    Dec(N);
                end;
            end;
            if FChunkState = httpChunkGetExt then begin
                { Here we simply ignore until next LF }
                while N > 0 do begin
//                  if P^ = #10 then begin
                    if Ord(FReceiveBuffer[P]) = 10 then begin // FP 09/09/06
                        if FChunkLength = 0 then              // AG V7.18
                            FChunkState := httpChunkDone      // AG V7.18
                        else                                  // AG V7.18
                            FChunkState := httpChunkGetData;
                        Inc(P);
                        Dec(N);
                        break;
                    end;
                    Inc(P);
                    Dec(N);
                end;
            end;
            if FChunkState = httpChunkGetData then begin
                K := FChunkLength - FChunkRcvd;
                if K > N then
                    K := N;
                if K > 0 then begin
                    N := N - K;
                    FRcvdCount := FRcvdCount + K;
                    FChunkRcvd := FChunkRcvd + K;
                {$IFDEF UseContentCoding}
                    FContentCodingHnd.WriteBuffer(@FReceiveBuffer[P], K);   // FP 09/09/06
                {$ELSE}
                    if Assigned(FRcvdStream) then
                        FRcvdStream.WriteBuffer(FReceiveBuffer[P], K);
                    TriggerDocData(@FReceiveBuffer[P], K);
                {$ENDIF}
                    P := P + K;
                end;
                if FChunkRcvd >= FChunkLength then
                    FChunkState := httpChunkSkipDataEnd;
            end;
            if FChunkState = httpChunkSkipDataEnd then begin
                while N > 0 do begin
                    if Ord(FReceiveBuffer[P]) = 10 then begin  // FP 09/09/06
                        if FChunkLength = 0 then
                            { Last chunk is a chunk with length = 0 }
                            FChunkState  := httpChunkDone
                        else
                            FChunkState  := httpChunkGetSize;
                        FChunkLength := 0;
                        FChunkRcvd   := 0;
                        Inc(P);
                        Dec(N);
                        break;
                    end;
                    Inc(P);
                    Dec(N);
                end;
            end;
        end;
        if FChunkState = httpChunkDone then begin
{$IFNDEF NO_DEBUG_LOG}
            if CheckLogOptions(loProtSpecInfo) then  { V1.91 } { replaces $IFDEF DEBUG_OUTPUT  }
                DebugLog(loProtSpecInfo, 'httpChunkDone, end of document');
{$ENDIF}
            FBodyStartedFlag := False;  { V8.67 was FBodyLineCount }
            FNext          := nil;
            StateChange(httpBodyReceived);
            TriggerDocEnd;
            if (FCloseReq) then     { SAE 01/06/04 }
                FCtrlSocket.CloseDelayed
        end;
    end
    else begin
        if FBodyDataLen > 0 then begin
            FRcvdCount := FRcvdCount + FBodyDataLen;
{$IFDEF UseContentCoding}
            FContentCodingHnd.WriteBuffer(@FReceiveBuffer[FBodyData], FBodyDataLen); // FP 09/09/06
{$ELSE}
            if Assigned(FRcvdStream) then
                FRcvdStream.WriteBuffer(FReceiveBuffer[FBodyData], FBodyDataLen);
            TriggerDocData(@FReceiveBuffer[FBodyData], FBodyDataLen);
{$ENDIF}
        end;

        if FRcvdCount = FContentLength then begin
            { End of document }
{$IFNDEF NO_DEBUG_LOG}
            if CheckLogOptions(loProtSpecInfo) then  { V1.91 } { replaces $IFDEF DEBUG_OUTPUT  }
                DebugLog(loProtSpecInfo, 'End of document');
{$ENDIF}
            FBodyStartedFlag := False;   { V8.67 was FBodyLineCount }
            FNext          := nil;
            StateChange(httpBodyReceived);
            TriggerDocEnd;
            if {(FResponseVer = '1.0') or (FRequestVer = '1.0') or  }
                { see above                                }
                { [rawbite 31.08.2004 Connection controll] }
                (FCloseReq) then     { SAE 01/06/04 }
                FCtrlSocket.CloseDelayed
            else if not FLocationFlag then
                CheckDelaySetReady;  { 09/26/08 ML }
        end;
    end;
{$IFNDEF NO_DEBUG_LOG}
    if CheckLogOptions(loProtSpecInfo) then  { V1.91 } { replaces $IFDEF DEBUG_OUTPUT  }
            DebugLog(loProtSpecInfo, 'GetBodyLineNext end');
{$ENDIF}
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure THttpCli.GetHeaderLineNext;
var
    proto   : String;
    user    : String;
    pass    : String;
    port    : String;
    Host    : String;
    Path    : String;
    Field   : String;
    Data    : String;
    nSep    : Integer;
    tmpInt  : LongInt;
    bAccept : Boolean;
    DocExt  : String;


   { V8.67 ensure relocation path has no spaces or fragment/anchor # }
    function EncodePathOnly(const OldPath: String): String;
    var
        I: Integer;
    begin
        Result := OldPath;
        I := Pos('#', OldPath);
        if I > 1 then
           Result := Copy (OldPath, 1, I - 1);
        if Pos(IcsSpace, OldPath) = 0 then Exit;
        Result := StringReplace(OldPath, IcsSpace, '%20', [rfReplaceAll])
    end;

begin
    if FHeaderLineCount = 0 then
        TriggerHeaderBegin
    else if FHeaderLineCount = -1 then   { HTTP/1.1 second header }
        FHeaderLineCount := 0;
    Inc(FHeaderLineCount);

    { Some server send HTML document without header ! I don't know if it is  }
    { legal, but it exists (AltaVista Discovery does that).                  }
    if (FHeaderLineCount =  1)   and
       (FLastResponse    <> '')  and
       (FLastResponse[1] =  '<') and
       (SameText(Copy(FLastResponse, 1, 6), '<HTML>') or
        SameText(Copy(FLastResponse, 1, 9), '<!DOCTYPE')) then begin
        if FContentType = '' then
            FContentType := 'text/html';
        StateChange(httpWaitingBody);
        FNext := GetBodyLineNext;
        TriggerHeaderEnd;
        GetBodyLineNext;
        Exit;
    end;

    if FLastResponse = '' then begin
{$IFNDEF NO_DEBUG_LOG}
        if CheckLogOptions(loProtSpecInfo) then  { V1.91 } { replaces $IFDEF DEBUG_OUTPUT  }
            DebugLog(loProtSpecInfo, 'End of header');
{$ENDIF}
        if (FResponseVer = '1.1') and (FStatusCode = 100) then begin
            { HTTP/1.1 continue message. A second header follow. }
            { I should create an event to give access to this.   }
            FRcvdHeader.Clear;        { Cancel this first header }
            FHeaderLineCount := -1;   { -1 is to remember we went here }
            Exit;
        end;

        TriggerHeaderEnd;  { 28/12/2003 }
        if FState = httpReady then begin    { 05/02/2005 }
            { It is likely that Abort has been called in OnHeaderEnd event }
            FReceiveLen := 0;               { Clear any buffered data }
            Exit;
        end;

        { FContentLength = -1 when server doesn't send a value }
        if ((FContentLength = -1) and            { Added 12/03/2004 }
            (FTransferEncoding <> 'chunked') and { Added 09/10/2006 by FP }
            ((FStatusCode < 200) or              { Added 12/03/2004 }
             (FStatusCode = 204) or              { Added 12/03/2004 }
             (FStatusCode = 301) or              { Added 06/10/2004 }
             (FStatusCode = 302) or              { Added 06/10/2004 }
             (FStatusCode = 304)))               { Added 12/03/2004 }
             or
              (FContentLength = 0)
             or
              (FRequestType = httpHEAD) then begin
            if FCloseReq then begin
                if FLocationFlag then          { Added 16/02/2004 }
                    StartRelocation            { Added 16/02/2004 }
                else begin                     { Added 16/02/2004 }
                    if FRequestType = httpHEAD then begin { Added 23/07/04 }
                        { With HEAD command, we don't expect a document }
                        { but some server send one !                    }
                        FReceiveLen := 0;      { Cancel received data   }
                        StateChange(httpWaitingBody);
                        FNext := nil;
                    end;
                    FCtrlSocket.CloseDelayed;  { Added 10/01/2004 }
                end;
            end
            else begin
                if FLocationFlag then     { V8.67 do before checking HEAD, or get stuck here }
                    StartRelocation
                else begin
                    if FRequestType = httpHEAD then begin            //AG 05/27/08
                        { With HEAD command, we don't expect a document } //AG 05/27/08
                        { but some server send one !                    } //AG 05/27/08
                        FReceiveLen := 0;      { Cancel received data   } //AG 05/27/08
                        StateChange(httpWaitingBody);                     //AG 05/27/08
                        FNext := nil;                                     //AG 05/27/08
                        SetReady;                                         //AG 05/27/08
                    end                                                   //AG 05/27/08
                    else
                        CheckDelaySetReady;  { 09/26/08 ML }
                end;
            end;
            Exit;
        end;
        DocExt := LowerCase(ExtractFileExt(FDocName));
        if (DocExt = '.exe') or (DocExt = '') then begin
            if FContentType = 'text/html' then
                ReplaceExt(FDocName, 'htm');
        end;

        StateChange(httpWaitingBody);
        FNext := GetBodyLineNext;
        if FReceiveLen > 0 then begin
            FBodyData    := 0;  // FP 09/09/06
            if (FContentLength < 0) or
               ((FRcvdCount + FReceiveLen) <= FContentLength) then
                FBodyDataLen := FReceiveLen
            else
                FBodyDataLen := FContentLength - FRcvdCount;  {****}
            GetBodyLineNext;
            FReceiveLen := FReceiveLen - FBodyDataLen;
            { Move remaining data to start of buffer. 17/01/2004 }
            if FReceiveLen > 0 then
                IcsMoveTBytes(FReceiveBuffer, FBodyDataLen, 0, FReceiveLen + 1)
            else if FReceiveLen < 0 then  { V8.03 }
                FReceiveLen := 0;         { V8.03 }
        end;
        if not Assigned(FNext) then begin
            { End of document }
            if FLocationFlag then
                StartRelocation
            else
                CheckDelaySetReady; { 09/26/08 ML }
        end;
        Exit;
    end;

    FRcvdHeader.Add(FLastResponse);

    nSep := Pos(':', FLastResponse);
    if (FHeaderLineCount = 1) then begin
        if (Copy(FLastResponse, 1, 8) = 'HTTP/1.0') or
           (Copy(FLastResponse, 1, 8) = 'HTTP/1.1') then begin
            FResponseVer  := Copy(FLastResponse, 6, 3);
            { Reset the default FCloseReq flag depending on the response 12/29/05 AG }
            if (FRequestVer = '1.1') and (FResponseVer = '1.0') then
                FCloseReq := TRUE
            else begin
                if FRequestVer = '1.0' then
                    FCloseReq := TRUE
                else if FRequestVer = '1.1' then
                    FCloseReq := FALSE;
            end;
       {$IFNDEF NO_DEBUG_LOG}                                           { V1.91 }
            if CheckLogOptions(loProtSpecDump) then begin
                DebugLog(loProtSpecDump, 'FCloseReq=' + IntToStr(Ord(FCloseReq)));
            end;
        {$ENDIF}
            { Changed 12/22/05 AG - M$ Proxy 2.0 invalid status-line ("HTTP/1.0  200") }
            tmpInt := 9;
            while Length(FLastResponse) > tmpInt do begin
                Inc(tmpInt);
                if AnsiChar(FLastResponse[tmpInt]) in ['0'..'9'] then
                    break;
            end;
            FStatusCode   := StrToIntDef(Copy(FLastResponse, tmpInt, 3), 0);  { V8.13 }
            FReasonPhrase := Copy(FLastResponse, tmpInt + 4, Length(FLastResponse));
            { Changed end }
        end
        else begin
            { Received data but not part of a header }
            if Assigned(FOnDataPush2) then
                FOnDataPush2(Self);
        end;
    end
    else if nSep > 0 then begin
        Field := LowerCase(Copy(FLastResponse, 1, nSep - 1));
        { Skip spaces }
        Inc(nSep);
        while (nSep < Length(FLastResponse)) and
              (FLastResponse[nSep] = ' ') do
              Inc(nSep);
        Data  := Copy(FLastResponse, nSep, Length(FLastResponse));

       { V8.71 JK allow raw header modification and logging before processing }
        TriggerHeaderFieldData(Field, Data);
        if Field = 'location' then begin { Change the URL ! }
       { V8.64 Location is A-Label (Punycode ASCII with ACE xn--), leave it alone
           and only convert to Unicode for the read only Location property }
            if Copy(Data, 1, 2) = '//' then         { V7.22 }
                Data := FProtocol + ':' + Data;     { V7.22 }
            if FRequestType in [httpPUT, httpPATCH] then begin   { V8.06 }
                 { Location just tell us where the document has been stored }
                 FLocation := Data;
            end

          { V8.60 201 created means newly created resource }
            else if (StatusCode = 201) then begin
                 FLocation := Data;
            end

          { V8.60 301, 302, 303, 307 and 308 mean relocation to new relative or absolute URL  }
          { ignore 4xx and 5xx responses }
          { NOTE we don't set FLocation if we are actually relocating somewhere, only for data  }
            else if FFollowRelocation and    {TED}
                    (FStatusCode >= 301) and (FStatusCode <= 308) then begin  { V8.60 not for 201 }
                { OK, we have a real relocation !       }
                FLocationFlag := TRUE;
                if Proxy <> '' then begin
                    { We are using a proxy }
                    if Data[1] = '/' then begin
                        { Absolute location }
                        ParseURL(FPath, proto, user, pass, Host, port, Path);
                    { V8.64 need Unicode for SSL }
                        Host := IcsIDNAToUnicode(Host);
                        if Proto = '' then
                            Proto := 'http';
                        FLocation := Proto + '://' + Host + EncodePathOnly(Data);  { V8.67 ensure path is legal without spaces }
                        FPath     := FLocation;

                        if (user <> '') and (pass <> '') then begin
                            { save user and password given in location @@@}
                            FCurrUsername   := user;
                            FCurrPassword   := pass;
                        end;
                    end
                    else if NOT IsKnownProtocolURL(Data)           { V8.71 JK }
                        then begin
                        { Relative location }
                        FPath     := GetBaseUrl(FPath) + EncodePathOnly(Data);  { V8.67 ensure path is legal without spaces }
                        FLocation := FPath;
                    end
                    else begin
                        ParseURL(Data, proto, user, pass, Host, port, Path);
                        Path := EncodePathOnly(Path);  { V8.67 ensure path is legal without spaces }
                    { V8.64 need Unicode for SSL }
                        Host := IcsIDNAToUnicode(Host);
                        if port <> '' then
                            FPort := port
                        else
                            FPort := GetProtocolPort(proto);     { V8.71 JK }

                        if (user <> '') and (pass <> '') then begin
                            { save user and password given in location @@@}
                            FCurrUsername   := user;
                            FCurrPassword   := pass;
                        end;

                        if (Proto <> '') and (Host <> '') then begin
                            { We have a full relocation URL }
                            FTargetHost := Host;
                            if Port <> '' then begin { V8.01 }
                                FLocation := Proto + '://' + Host + ':' + Port + Path;
                                FTargetPort := Port;
                            end
                            else
                                FLocation := Proto + '://' + Host + Path;
                            FPath := FLocation;
                        end
                        else begin
                            if Proto = '' then
                                Proto := 'http';
                            if FPath = '' then
                                FLocation := Proto + '://' + FTargetHost + '/' + Host
                            else if Host = '' then
                                FLocation := Proto + '://' + FTargetHost + FPath
                            else
                                FTargetHost := Host;
                        end;
                    end;
                end
                { We are not using a proxy }
                else begin
                    ParseURL(FURL, proto, user, pass, Host, port, Path); { V7.03 }
                    if Data[1] = '/' then begin
                        { Absolute location }
                        FPath := EncodePathOnly(Data);  { V8.67 ensure path is legal without spaces }
                        if Proto = '' then
                            Proto := 'http';
                        FLocation := Proto + '://' + FHostName + FPath;  { Unicode }
                    end
                    else if NOT IsKnownProtocolURL(Data) then begin        { V8.71 JK }
                        { Relative location }
                        FPath :=  EncodePathOnly(GetBaseUrl(FPath) + Data);  { V8.67 ensure path is legal without spaces }
                        if Proto = '' then
                            Proto := 'http';
                        FLocation := Proto + '://' + FHostName + FPath;
                    end
                    else begin
                        ParseURL(Data, proto, user, pass, FHostName, port, FPath);
                        FPath := EncodePathOnly(FPath);  { V8.67 ensure path is legal without spaces }
                    { V8.64 need Unicode for SSL }
                        FHostName := IcsIDNAToUnicode(FHostName);
                        if port <> '' then
                            FPort := port
                        else
                            FPort := GetProtocolPort(proto);                    { V8.71 JK }

                        FProtocol := Proto;

                        if (user <> '') and (pass <> '') then begin
                            { save user and password given in location @@@}
                            FCurrUsername   := user;
                            FCurrPassword   := pass;
                        end;

                        if (Proto <> '') and (FHostName <> '') then begin
                            { We have a full relocation URL }
                            FTargetHost := FHostName;
                            if FPath = '' then begin
                                FPath := '/';
                                if Port <> '' then begin { V8.01 }
                                    FLocation := Proto + '://' + FHostName + ':' + Port;
                                    FTargetPort := Port;
                                end
                                else
                                    FLocation := Proto + '://' + FHostName;
                            end
                            else begin
                                if Port <> '' then begin { V8.01 }
                                    FLocation := Proto + '://' + FHostName + ':' + Port + FPath;
                                    FTargetPort := Port;
                                end
                                else
                                    FLocation := Proto + '://' + FHostName + FPath;
                            end;
                        end
                        else begin
                            if Proto = '' then
                                Proto := 'http';
                            if FPath = '' then begin
                                FLocation := Proto + '://' + FTargetHost + '/' + FHostName;
                                FHostName := FTargetHost;
                                FPath     := FLocation;          { 26/11/99 }
                            end
                            else if FHostName = '' then begin
                                FLocation := Proto + '://' + FTargetHost + FPath;
                                FHostName := FTargetHost;
                            end
                            else
                                FTargetHost := FHostName;
                        end;
                    end;
                end;
            end;
        end
        else if Field = 'content-length' then
            FContentLength := StrToInt64Def(Trim(Data), -1)
        else if Field = 'transfer-encoding' then
            FTransferEncoding := LowerCase(Data)
        else if Field = 'content-range' then begin                             {JMR!! Added this line!!!}
            tmpInt := Pos('-', Data) + 1;                                      {JMR!! Added this line!!!}
            FContentRangeBegin := Copy(Data, 7, tmpInt-8);                     {JMR!! Added this line!!!}
            FContentRangeEnd   := Copy(Data, tmpInt, Pos('/', Data) - tmpInt); {JMR!! Added this line!!!}
        end                                                                    {JMR!! Added this line!!!}
        else if Field = 'accept-ranges' then
            FAcceptRanges := Data
        else if Field = 'content-type' then
            FContentType := LowerCase(Data)
        else if Field = 'www-authenticate' then
            FDoAuthor.add(Data)
        else if Field = 'proxy-authenticate' then              { BLD required for proxy NTLM authentication }
            FDoAuthor.add(Data)
        else if Field = 'set-cookie' then begin
            bAccept := TRUE;
            TriggerCookie(Data, bAccept);
        end
        { rawbite 31.08.2004 Connection controll }
        else if (Field = 'connection') or
                (Field = 'proxy-connection') then begin
            if (LowerCase(Trim(Data)) = 'close') then
                FCloseReq := TRUE
            else if (LowerCase(Trim(Data)) = 'keep-alive') then
                FCloseReq := FALSE;
        end
        else if Field = 'date' then begin     { V8.61 }
            try
                FRespDateDT := RFC1123_StrToDate(Data) ;
            except
                FRespDateDT := 0 ;
            end ;
        end
        else if Field = 'last-modified' then begin     { V8.61 }
            try
                FRespLastModDT := RFC1123_StrToDate(Data) ;
            except
                FRespLastModDT := 0 ;
            end ;
        end
        else if Field = 'expires' then begin     { V8.61 }
            try
                FRespExpires := RFC1123_StrToDate(Data) ;
            except
                FRespExpires := 0 ;
            end ;
        end
        else if Field = 'age' then      { V8.61 }
            FRespAge := atoi(Data)
        else if Field = 'cache-control' then      { V8.61 }
            FRespCacheControl := Data     // should really parse field
        else if Field = 'etag' then               { V8.68 }
            FResponseEtag := Data
    {   else if Field = 'mime-version' then }
    {   else if Field = 'pragma' then }
    {   else if Field = 'allow' then }
    {   else if Field = 'server' then }
    {   else if Field = 'content-encoding' then }
{$IFDEF UseContentCoding}
        else if Field = 'content-encoding' then
          FContentEncoding := Data
{$ENDIF}
    {   else if Field = 'expires' then }
   end
   else { Ignore  all other responses }
       ;

   TriggerHeaderData;   { V8.61 }

{    if FStatusCode >= 400 then    Moved above 01/11/01 }
{        FCtrlSocket.Close;                             }
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure THttpCli.InternalClear;
begin
    FRcvdHeader.Clear;
    FRequestDoneError := httperrNoError;
    FDocName          := '';
    FStatusCode       := 0;
    FRcvdCount        := 0;
    FReceiveLen       := 0;   { V7.10 }
    FSentCount        := 0;
    FHeaderLineCount  := 0;
    FBodyStartedFlag  := False;   { V8.67 was FBodyLineCount }
    FContentLength    := -1;
    FContentType      := '';  { 25/09/1999 }
    FTransferEncoding := '';  { 28/12/2003 }
    FRespDateDT       := 0;   { V8.61 }
    FRespLastModDT    := 0;   { V8.61 }
    FRespExpires      := 0;   { V8.61 }
    FRespAge          := -1;  { V8.61 }
    FRespCacheControl := '';  { V8.61 }
//    FPunyCodeHost     := '';  { V8.64 connection may still be open }
{$IFDEF UseContentCoding}
    FContentEncoding  := '';
{$ENDIF}
    FAllowedToSend    := FALSE;
    FDelaySetReady    := FALSE;     { 09/26/08 ML }
    FLocation         := FURL;
    FDoAuthor.Clear;
    SetLength(FWWWAuthInfos, 0);   { V8.69 }

    { if protocol version is 1.0 then we suppose that the connection must be }
    { closed. If server response will contain a Connection: keep-alive header }
    { we will set it to False.                                                }
    { If protocol version is 1.1 then we suppose that the connection is kept  }
    { alive. If server response will contain a Connection: close  we will set }
    { it to True.                                                             }
    if FRequestVer = '1.0' then
        FCloseReq := TRUE  { SAE 01/06/04 }
    else
        FCloseReq := FALSE { [rawbite 31.08.2004 Connection controll] }
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure THttpCli.DoRequestAsync(Rq : THttpRequest);
var
    Proto, User, Pass, Host, Port, Path: String;
    I: Integer;
begin
    if (Rq <> httpCLOSE) and (FState <> httpReady) then
        raise EHttpException.Create('HTTP component ' + Name + ' is busy', httperrBusy);

    if (Rq in [httpPOST, httpPUT, httpPATCH]) and    { V8.06 }
       (not Assigned(FSendStream)
       { or (FSendStream.Position = FSendStream.Size)}   { Removed 21/03/05 }
       ) then
        raise EHttpException.Create('HTTP component has nothing to post, put or patch',
                                    httpErrNoData);

    if Rq = httpCLOSE then begin
        FStatusCode   := 200;
        FReasonPhrase := 'OK';
        FRequestDoneError := httperrNoError;  { V8.71 JK 21/08/2013 }
        StateChange(httpClosing);
        if FCtrlSocket.State = wsClosed then begin
            FLocationFlag := False;    { 7.23 }
            FRequestType := Rq;        { 7.23 }
            InternalClear;             { 7.23 }
            SetReady;
        end
        else
            FCtrlSocket.CloseDelayed;
        Exit;
    end;

    { Clear all internal state variables }
    FRequestType := Rq;
    InternalClear;

    FCurrUsername        := FUsername;
    FCurrPassword        := FPassword;
    FCurrConnection      := FConnection;
    FCurrProxyConnection := FProxyConnection;

    { V8.62 if proxy URL is passed, parse it as proxy properties }
    { http://[user[:password]@]host:port }
    if (Length(FProxyURL) > 6) and (Pos (':', Copy(FProxyURL, 6, 9999)) > 5) then begin
        ParseURL(FProxyURL, Proto, User, Pass, Host, Port, Path);
        { pending, check https for SSL proxy, maybe socks for socks proxy }
        if Proto = 'http' then begin
            FProxy := Host;
            FProxyPort := Port;
            FProxyUsername := User;
            FProxyPassword := Pass;
            if (FProxyUsername <> '') and (FProxyPassword <> '') then
                FProxyAuth := httpAuthBasic;
        end;
    end;

    { Parse url and proxy to FHostName, FPath and FPort }
    if FProxy <> '' then begin
        ParseURL(FURL, Proto, User, Pass, Host, Port, Path);
        FTargetHost := Host;
        FTargetPort := Port;
        if FTargetPort = '' then
            FTargetPort := GetProtocolPort(Proto);        { V8.71 JK }
        FDocName := Path;
        if Path = '' then
            Path := '/';     { V8.69 not allowed blank path }
        if User <> '' then
            FCurrUserName := User;
        if Pass <> '' then
            FCurrPassword := Pass;
        { We need to remove usercode/Password from the URL given to the proxy }
        { but preserve the port                                               }
        if Port <> '' then
            Port := ':' + Port;
      { V8.64 for proxy use complete URL as path, converting IDN host to A-Label }
        Host := IcsIDNAToASCII(Host);
        if Proto = '' then
            FPath := 'http://'+ Host + Port + Path
        else if IcsLowerCase(Proto) = 'https' then
            FPath := Path  { V8.66 using proxy CONNECT command so don't need host and port }
        else
            FPath := Proto + '://' + Host + Port + Path;
        FProtocol := Proto;
        ParseURL(FProxy, Proto, User, Pass, Host, Port, Path);
        if Port = '' then
            Port := ProxyPort;
    end
    else begin
        ParseURL(FURL, Proto, User, Pass, Host, Port, FPath);
        FTargetHost := Host;
        FDocName    := FPath;
        FProtocol   := Proto;
        if User <> '' then
            FCurrUserName := User;
        if Pass <> '' then
            FCurrPassword := Pass;
        if Port = '' then
            Port := GetProtocolPort(Proto);        { V8.71 JK }
        FTargetPort := Port;  {added 11/13/2005 AG}
    end;
    if FProtocol = '' then
        FProtocol := 'http';
    if Proto = '' then
        Proto := 'http';

  { V8.69 remove # fragment anchor from URL, only used by browser }
    if NOT (httpoAllowAnchor in FOptions) then begin
        I := Pos('#', FPath);
        if I > 0 then
            FPath := Copy(FPath, 1, I - 1);
    end;
    if FPath = '' then
        FPath := '/';
    if (FPath = '/*') and (Rq = httpOPTIONS) then  { V8.09 }
        FPath := '*';

    AdjustDocName;

 { host and port we'll connect to, Unicode }
    FHostName   := Host;
    FPort       := Port;

{$IFDEF UseNTLMAuthentication}
    FAuthNTLMState       := ntlmNone;
    FProxyAuthNTLMState  := ntlmNone;
{$ENDIF}
{$IFDEF UseDigestAuthentication}
    FAuthDigestState      := digestNone;
    FProxyAuthDigestState := digestNone;
{$ENDIF}
    FAuthBasicState      := basicNone;
    FProxyAuthBasicState := basicNone;

    if (FProxy <> '') and (FProxyAuth <> httpAuthNone) and
       (FProxyUsername <> '') and (FProxyPassword <> '') then begin
        { If it is still connected there is no need to restart the
          authentication on the proxy }
        if (FCtrlSocket.State = wsConnected)     and
           (FHostName        = FCurrentHost)     and
           (FPort            = FCurrentPort)     and
           (FProtocol        = FCurrentProtocol) then begin
{$IFDEF UseNTLMAuthentication}
            if FProxyAuth <> httpAuthNtlm then begin
                FProxyAuthNTLMState  := ntlmDone;
                if (FRequestVer = '1.0') or (FResponseVer = '1.0') or  // <== 12/29/05 AG
                   (FResponseVer = '') then                            // <== 12/29/05 AG
                    FCurrProxyConnection := 'Keep-alive';
            end
            else
{$ENDIF}
{$IFDEF UseDigestAuthentication}
            if FProxyAuth in [httpAuthDigest, httpAuthDigest2] then   { V8.69 }
                FProxyAuthDigestState := digestDone
            else
{$ENDIF}
            if FProxyAuth = httpAuthBasic then
                FProxyAuthBasicState := basicDone;
        end
        else begin
{$IFDEF UseNTLMAuthentication}
            if FProxyAuth = httpAuthNtlm then begin
                FProxyAuthNTLMState  := ntlmMsg1;
                if (FRequestVer = '1.0') or (FResponseVer = '1.0') or  // <== 12/29/05 AG
                   (FResponseVer = '') then                            // <== 12/29/05 AG
                    FCurrProxyConnection := 'Keep-alive';
            end
            else
{$ENDIF}
{$IFDEF UseDigestAuthentication}
            if FProxyAuth in [httpAuthDigest, httpAuthDigest2] then   { V8.69 }
                FProxyAuthDigestState := digestDone
            else
{$ENDIF}
            if FProxyAuth = httpAuthBasic then
                FProxyAuthBasicState := basicMsg1;
        end;
    end;

    if (FServerAuth <> httpAuthNone) and (FCurrUsername <> '') and
       (FCurrPassword <> '') then begin
{$IFDEF UseNTLMAuthentication}
        if FServerAuth = httpAuthNtlm then begin
            FAuthNTLMState  := ntlmMsg1;
            if (FRequestVer = '1.0') or (FResponseVer = '1.0') or   // <== 12/29/05 AG
               (FResponseVer = '') then                             // <== 12/29/05 AG
                FCurrConnection := 'Keep-alive';
        end
        else
{$ENDIF}
{$IFDEF UseDigestAuthentication}
        if FServerAuth in [httpAuthDigest, httpAuthDigest2] then   { V8.69 }
            FAuthDigestState := digestDone
        else
{$ENDIF}
        if FServerAuth = httpAuthBasic then
            FAuthBasicState := basicMsg1;
    end;

    if FCtrlSocket.State = wsConnected then begin
        if (FHostName = FCurrentHost)     and
           (FPort     = FCurrentPort)     and
           (FProtocol = FCurrentProtocol) then begin
            { We are already connected to the right host ! }
            SocketSessionConnected(Self, 0);
            Exit;
        end;
        { Connected to another website. Abort the connection }
        FCtrlSocket.Abort;
    end;

    FProxyConnected := FALSE;
    { Ask to connect. When connected, we go at SocketSeesionConnected. }
    StateChange(httpNotConnected);
    Login;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure THttpCli.AdjustDocName;
var
    I : Integer;
begin
    I := Pos('?', FDocName);
    if I > 0 then
        FDocName := Copy(FDocName, 1, I - 1);

    if FRequestType = httpOptions then  { V8.09 options method may be *, user name or anything }
        FDocName := 'options.htm'
    else if (FDocName = '') or (FDocName[Length(FDocName)] = '/') then
        FDocName := 'document.htm'
    else begin
        if FDocName[Length(FDocName)] = '/' then
            SetLength(FDocName, Length(FDocName) - 1);
        FDocName := Copy(FDocName, Posn('/', FDocName, -1) + 1, 255);
        I := Pos('?', FDocName);
        if I > 0 then
            FDocName := Copy(FDocName, 1, I - 1);
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function THttpCli.GetProtocolPort(const AProtocol: String): String;     { V8.71 JK }
begin
{$IFDEF USE_SSL}
    if SameText(AProtocol, 'https') then
        Result := '443'
    else
{$ENDIF}
        Result := '80';
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function THttpCli.IsSSLProtocol(const AProtocol: String): Boolean;    { V8.71 JK }
begin
  Result := SameText(AProtocol, 'https' );
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function THttpCli.IsKnownProtocol(const AProtocol: String): Boolean;   { V8.71 JK }
begin
  Result :=
{$IFDEF USE_SSL}
            SameText(AProtocol, 'https' ) or
{$ENDIF}
            SameText(AProtocol, 'http');
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function THttpCli.IsKnownProtocolURL(const AURL: String): Boolean;    { V8.71 JK }
begin
  Result := (CompareText(Copy(AURL, 1, 7), 'http://') = 0) or
            (CompareText(Copy(AURL, 1, 8), 'https://') = 0);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure THttpCli.DoRequestSync(Rq : THttpRequest);  { V7.04 Timeout added }
var
    TimeOutMsec     : UINT;
    bFlag           : Boolean;
    AbortRequired   : Boolean;         { V8.71 JK }
    AbortMsg        : String;          { V8.71 JK }
begin
    DoRequestAsync(Rq);
    if not Assigned(FCtrlSocket.Counter) then
        FCtrlSocket.CreateCounter;
    FCtrlSocket.Counter.LastSendTick := IcsGetTickCount64; // Reset counter      { V8.71 }
    TimeOutMsec := FTimeOut * 1000;
    while FState <> httpReady do begin
      {$IFDEF MSWINDOWS}
        if MsgWaitForMultipleObjects(0, Pointer(nil)^, FALSE, 1000,
                                     QS_ALLINPUT) = WAIT_OBJECT_0 then
      {$ENDIF}
            MessagePump;


      { V8.71 JK see if user wants to abandon this request }
        AbortRequired := False;
        AbortMsg := '';
        if Assigned(FOnSyncRequestWait) then
            FOnSyncRequestWait(Self, AbortRequired, AbortMsg);

        if (FState <> httpReady) and (Terminated or (IcsElapsedMsecs64(FCtrlSocket.Counter.LastAliveTick) >= TimeOutMsec)) then begin   { V8.71 }
            bFlag := (FState = httpDnsLookup);
            StateChange(httpAborting);

            if bFlag then
            try
                FCtrlSocket.CancelDnsLookup;
            except
                { Ignore any exception }
            end;
            FStatusCode := 404;
            if Terminated then begin
                FReasonPhrase := 'Request aborted on termination';  { V8.68 }
                FRequestDoneError := httperrAborted;
            end
            else if AbortRequired then begin          { V8.71 JK }
                if AbortMsg = '' then
                    AbortMsg := 'Request aborted';
                FReasonPhrase := AbortMsg;
                FRequestDoneError := httperrAborted;
            end
            else begin
                FReasonPhrase     := 'Request aborted on timeout';
                FRequestDoneError := httperrCustomTimeOut;
            end;
            if bFlag then
                SocketSessionClosed(Self, 0)
            else
                FCtrlSocket.Close;
            StateChange(httpReady);
        end;
    end;

{* Jul 12, 2004
   WARNING: The component now doesn't consider 401 status
            as a fatal error (no exception is triggered). This required a
            change in the application code if it was using the exception that
            is no more triggered for status 401 and 407.
*}
    {* if FStatusCode > 401 then    Dec 14, 2004 *}
    if NOT FResponseNoException then begin  { V8.54 should error exceptions be skipped? }
        if FRequestDoneError <> httperrNoError then                       { V7.23 }
            raise EHttpException.Create(GetEnumName(TypeInfo(THttpRequest), Ord(Rq)) +
                     ': Error# ' + IntToStr(FRequestDoneError) + FReasonPhrase, FRequestDoneError)  { V8.71 JK }
        else if (FStatusCode >= 400) and (FStatusCode <> 401) and (FStatusCode <> 407) then
            raise EHttpException.Create(GetEnumName(TypeInfo(THttpRequest), Ord(Rq)) +
                       ': Status# ' + IntToStr(FStatusCode) + FReasonPhrase, FStatusCode);          { V8.71 JK }
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure THttpCli.LoginDelayed;
begin
    if not FWMLoginQueued then
        FWMLoginQueued := PostMessage(Handle, FMsg_WM_HTTP_LOGIN, 0, 0);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure THttpCli.LocationSessionClosed(Sender: TObject; ErrCode: Word);
var
    Proto, User, Pass, Host, Port, Path : String;
    RealLocation                        : String;
    I                                   : Integer;
    AllowMoreRelocations                : Boolean;
begin
{$IFNDEF NO_DEBUG_LOG}
    if CheckLogOptions(loProtSpecInfo) then  { V8.55 }
        DebugLog(loProtSpecInfo, 'Starting LocationSessionClosed');
{$ENDIF}
  { Remove any bookmark from the URL }
    I := Pos('#', FLocation);
    if I > 0 then
        RealLocation := Copy(FLocation, 1, I - 1)
    else
        RealLocation := FLocation;

  {$IFDEF UseNTLMAuthentication}
    if FProxyAuthNtlmState <> ntlmNone then
        { Connection thru proxy with NTLM. Reset the AuthState. }
        FProxyAuthNtlmState := ntlmMsg1; //ntlmDone;
  {$ENDIF}

    if FWMLoginQueued then begin
    { StartRelocation already queued a new Login }
        FConnected      := FALSE;
        FProxyConnected := FALSE;
        FLocationFlag   := FALSE;
        { Clear header from previous operation }
        FRcvdHeader.Clear;
        { Clear status variables from previous operation }
        FHeaderLineCount  := 0;
        FBodyStartedFlag  := False;    { V8.67 was FBodyLineCount }
        FContentLength    := -1;
        FContentType      := '';
        FTransferEncoding := ''; { 28/12/2003 }
        FResponseVer      := ''; { V7.20 }
    {$IFDEF UseContentCoding}
        FContentEncoding  := '';
    {$ENDIF}
        Exit; //***
    end;

    { Parse the URL }
    ParseURL(RealLocation, Proto, User, Pass, Host, Port, Path);
    FDocName := Path;
    AdjustDocName;
    FConnected      := FALSE;
    FProxyConnected := FALSE;
    FLocationFlag   := FALSE;
    { When relocation occurs doing a POST, new relocated page has to be GET }
    {  if FRequestType = httpPOST then  }
    { angus V8.07  unless a 307 or 308 POST which must not revert to GET }
    {if (FRequestType = httpPOST) and not ((FStatusCode = 307) or (FStatusCode = 308)) then }
    { angus V8.08 - try and match how Chrome and Firefox handle POST relocation }
    if ((FStatusCode=303) and (FRequestType <> httpHEAD)) or
              ((FRequestType = httpPOST) and ((FStatusCode=301) or (FStatusCode=302))) then
        FRequestType  := httpGET;

    { Restore normal session closed event }
    FCtrlSocket.OnSessionClosed := SocketSessionClosed;

{  V1.90 25 Nov 2005 - restrict number of relocations to avoid continuous loops }
    inc (FLocationChangeCurCount) ;
    if FLocationChangeCurCount > FLocationChangeMaxCount then begin
        AllowMoreRelocations := false;
        if Assigned (FOnLocationChangeExceeded) then
            FOnLocationChangeExceeded(Self, FLocationChangeCurCount,
                                                     AllowMoreRelocations) ;
        if not AllowMoreRelocations then begin
            SetReady;  { angus V7.08 }
            exit;
        end;
    end ;

    { Trigger the location changed event }
    TriggerLocationChange;  { V8.61 }
    { Clear header from previous operation }
    FRcvdHeader.Clear;
    { Clear status variables from previous operation }
    FHeaderLineCount  := 0;
    FBodyStartedFlag  := False;    { V8.67 was FBodyLineCount }
    FContentLength    := -1;
    FContentType      := '';
    //FStatusCode       := 0; // Moved to Login
    FTransferEncoding := ''; { 28/12/2003 }
{$IFDEF UseContentCoding}
    FContentEncoding  := '';
{$ENDIF}
    FResponseVer      := ''; { V7.20 }
    { Adjust for proxy use  (Fixed: Nov 10, 2001) }
    if FProxy <> '' then
        FPort := ProxyPort;
    { Must clear what we already received }
    CleanupRcvdStream; {11/11/04}
    CleanupSendStream;
    { Restart at login procedure }
    LoginDelayed;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure THttpCli.WMHttpLogin(var msg: TMessage);
begin
    Login;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure THttpCli.SocketSessionClosed(Sender: TObject; ErrCode: Word);
begin
{$IFNDEF NO_DEBUG_LOG}
    if CheckLogOptions(loProtSpecInfo) then  { V1.91 } { replaces $IFDEF DEBUG_OUTPUT  }
            DebugLog(loProtSpecInfo, 'SessionClosed Error: ' + IntToStr(ErrCode));
{$ENDIF}
    FReceiveLen := 0;                  { AG 11 Jan 2009 always clear the buffer! }
    if ErrCode <> 0 then               { WM 15 sep 2002 }
        FRequestDoneError := ErrCode;  { WM 15 sep 2002 }
    FConnected      := FALSE;
    FProxyConnected := FALSE;
    if FHeaderEndFlag then begin
        { TriggerHeaderEnd has not been called yet }
        TriggerHeaderEnd;
        if FLocationFlag then            { 28/10/01 }
            LocationSessionClosed(Self, 0);
        Exit;
    end;
    if FBodyStartedFlag then begin     { V8.67 was FBodyLineCount }
        TriggerDocEnd;
    end;
{ Fix proposed by Corey Murtagh 20/08/2004 "POST freezing in httpWaitingBody" }
{ Also fix a problem when a relocation occurs without document.               }
{ Conditional compile will compile this fix by default. It's there because I  }
{ don't want to delete the original code before confirming everything is OK.  }
{$IFNDEF DO_NOT_USE_COREY_FIX}
    if FLocationFlag then
        LocationSessionClosed(Self, 0)
    else begin
        TriggerSessionClosed;
        if FState <> httpReady then begin
            if (FRequestDoneError = httperrNoError) and (FStatusCode = 0) then  { V7.23 }
            begin
                FRequestDoneError := httperrNoStatusCode;
                FReasonPhrase     := 'HTTP no status code (connection closed prematurely)';
            end;
            SetReady;
        end;
    end;
{$ELSE}
    TriggerSessionClosed;
    if (not FLocationFlag) and (FState <> httpReady) then
        { if you don't verify if component is in ready state,  }
        { OnRequestDone will be fired twice in some cases      }
        SetReady;
{$ENDIF}
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure THttpCli.SocketDataAvailable(Sender: TObject; ErrCode: Word);
var
    Len     : Integer;
    I       : Integer;
const
    BUF_SIZE = 66536;  { V8.65 was 8192 }
begin
    // Make FReceiveBuffer at least 8KB larger than actually received data
    if Length(FReceiveBuffer) < (FReceiveLen + BUF_SIZE) then begin
        SetLength(FReceiveBuffer, FReceiveLen + BUF_SIZE + 1);
        FReceiveBuffer[FReceiveLen + BUF_SIZE] := 0;  // Easy debug with an ending nul byte
    end;
    I := Length(FReceiveBuffer) - FReceiveLen - 1;     // Preserve the nul byte
    Len := FCtrlSocket.Receive(@FReceiveBuffer[FReceiveLen], I);

{$IFNDEF NO_DEBUG_LOG}
    if CheckLogOptions(loProtSpecInfo) then  { V1.91 } { replaces $IFDEF DEBUG_OUTPUT  }
        DebugLog(loProtSpecInfo, 'Data available. Len=' + IntToStr(Len));
{$ENDIF}
    if FRequestType = httpAbort then
        Exit;

    if Len <= 0 then begin
    {$IFNDEF NO_DEBUG_LOG}
        if CheckLogOptions(loProtSpecInfo) then  { V1.91 } { replaces $IFDEF DEBUG_OUTPUT  }
            DebugLog(loProtSpecInfo, '**data available. Len=' + IntToStr(Len));
    {$ENDIF}
        Exit;
    end;
    FReceiveLen := FReceiveLen + Len;
    FReceiveBuffer[FReceiveLen] := 0;

{$IFDEF USE_SSL}
    if FState = httpWaitingProxyConnect then begin
        { If connection failed to remote host, then we receive a normal }
        { HTTP reply from the proxy with a HTML message with error      }
        { message ! Something like:                                     }
        { "HTTP/1.0 200 OK<CRLF>header lines<CRLF><CRLF>document"       }
        { If connection success we receive                              }
        { "HTTP/1.0 200 Connection established<CRLF><CRLF>"             }
        { Some proxies return HTTP/1.0 200 OK. We must also check for   } {Bjornar}
        { Content-Length, since a proxy returns header only as reply to } {Bjornar}
        { CONNECT request.                                              } {Bjornar}
    {$IFNDEF NO_DEBUG_LOG}
        if CheckLogOptions(loProtSpecInfo) then  { V1.91 } { replaces $IFDEF DEBUG_OUTPUT  }
            DebugLog(loProtSpecInfo, 'Proxy connected: "' + PAnsiChar(FReceiveBuffer) + '"');
    {$ENDIF}
        FProxyConnected := TRUE;
        if ( {Bjornar - Start}
           (IcsTbytesStarts(FReceiveBuffer, 'HTTP/1.0 200') or
           IcsTbytesStarts(FReceiveBuffer,'HTTP/1.1 200') or
           IcsTbytesStarts(FReceiveBuffer, 'HTTP/1.0  200') or //M$ Proxy Server 2.0
           IcsTbytesStarts(FReceiveBuffer, 'HTTP/1.1  200')) //M$ Proxy Server 2.0 not tested ??
           and not
           ((IcsTbytesStarts(FReceiveBuffer, 'HTTP/1.1 200 OK') or
           IcsTbytesStarts(FReceiveBuffer, 'HTTP/1.0 200 OK')) and
           IcsTbytesContains(FReceiveBuffer, 'Content-Length:') and
           not IcsTbytesContains(FReceiveBuffer, 'Content-Length: 0'))
           ) then {Bjornar - End}
        begin
            { We have a connection to remote host thru proxy, we can start }
            { SSL handshake                                                }
        {$IFDEF UseNTLMAuthentication}
            if not (FProxyAuthNTLMState in [ntlmNone, ntlmDone]) then
                FProxyAuthNTLMState  := ntlmDone;
        {$ENDIF}
        {$IFDEF UseDigestAuthentication}
            if not (FProxyAuthDigestState in [digestNone, digestDone]) then
                FProxyAuthDigestState := digestDone;
        {$ENDIF}
            if not (FProxyAuthBasicState in [basicNone, basicDone]) then
                FProxyAuthBasicState := basicDone;

    {$IFNDEF NO_DEBUG_LOG}
            if CheckLogOptions(loProtSpecInfo) then  { V1.91 } { replaces $IFDEF DEBUG_OUTPUT  }
                DebugLog(loProtSpecInfo, 'Start SSL handshake');
    {$ENDIF}
            FReceiveLen                    := 0; { Clear input data }
            FCtrlSocket.OnSslHandshakeDone := SslHandshakeDone;
            FCtrlSocket.SslEnable          := TRUE;
            FCtrlSocket.StartSslHandshake;
            FState := httpWaitingHeader;
            Exit;
        end
        else
           { Continue as a normal HTTP request }
            FState := httpWaitingHeader;
    end;
{$ENDIF USE_SSL}

    if FState = httpWaitingBody then begin
        if FReceiveLen > 0 then begin
            if FRequestType = httpHEAD then begin   { 23/07/04 }
                { We are processing a HEAD command. We don't expect a document }
                { but some server send one anyway. We just throw it away and   }
                { abort the connection                                         }
                FReceiveLen := 0;
                FCtrlSocket.Abort;
                Exit;
            end;
//          FBodyData    := FReceiveBuffer;
            FBodyData    := 0;  // FP 09/09/06
            if (FContentLength < 0) or
               ((FRcvdCount + FReceiveLen) <= FContentLength) then
                FBodyDataLen := FReceiveLen
            else
                FBodyDataLen := FContentLength - FRcvdCount;
            GetBodyLineNext;

            FReceiveLen  := FReceiveLen - FBodyDataLen;   {+++++}
            { Move remaining data to start of buffer. 17/01/2004 }
            if FReceiveLen > 0 then
                IcsMoveTBytes(FReceiveBuffer, FBodyDataLen, 0, FReceiveLen + 1);

            FBodyDataLen := 0;

            if Assigned(FNext) then
                FNext
            else if FLocationFlag then   { 28/12/2003 }
                StartRelocation
            else
                CheckDelaySetReady; { 09/26/08 ML }
        end;
        { FReceiveLen := 0;   22/02/02 }
        Exit;
    end;

    while FReceiveLen > 0 do begin
        I := 0;                                                   // FP 09/09/06
        while (I <= FReceiveLen) and (Ord(FReceiveBuffer[I]) <> 10) do // FP 09/09/06
            Inc(I);                                               // FP 09/09/06
        if I > FReceiveLen then
            break;
        if I = 0 then                                             // FP 09/09/06
            SetLength(FLastResponse, 0)                           // FP 09/09/06
        else begin                                                // FP 09/09/06
            if (I > 0) and (Ord(FReceiveBuffer[I - 1]) = 13) then // FP 09/09/06
                SetLength(FLastResponse, I - 1)                   // FP 09/09/06
            else                                                  // FP 09/09/06
                SetLength(FLastResponse, I);                      // FP 09/09/06
            if Length(FLastResponse) > 0 then                     // FP 09/09/06
                IcsMoveTBytesToString(FReceiveBuffer, 0,
                        FLastResponse, 1, Length(FLastResponse)); // FP 09/09/06
        end;                                                      // FP 09/09/06

{$IFNDEF NO_DEBUG_LOG}
        if CheckLogOptions(loProtSpecDump) then { V1.91 } { replaces $IFDEF DEBUG_OUTPUT  }
                DebugLog(loProtSpecDump, '>|' + FLastResponse + '|');
{$ENDIF}
        FReceiveLen := FReceiveLen - I - 1;                               // FP 09/09/06
        if FReceiveLen > 0 then begin
            IcsMoveTBytes(FReceiveBuffer, I + 1, 0, FReceiveLen);  // FP 09/09/06
        end
        else if FReceiveLen < 0 then                           // AG 03/19/07
            FReceiveLen := 0;                                  // AG 03/19/07

        if FState in [httpWaitingHeader, httpWaitingBody] then begin
            if Assigned(FNext) then
                FNext
            else
                CheckDelaySetReady; { 09/26/08 ML }
        end
        else begin
            { We are receiving data outside of any request. }
            { It's a server push.                           }
            if Assigned(FOnDataPush) then
                FOnDataPush(Self, ErrCode);
        end;
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure THttpCli.StartRelocation;
var
    SaveLoc : String;
    AllowMoreRelocations : Boolean;
    SavedStatus: integer;
begin
{$IFNDEF NO_DEBUG_LOG}
    if CheckLogOptions(loProtSpecInfo) then  { V1.91 } { replaces $IFDEF DEBUG_OUTPUT  }
        DebugLog(loProtSpecInfo, 'Starting relocation process');
{$ENDIF}
    FRcvdCount        := 0;
    FReceiveLen       := 0;
    FHeaderLineCount  := 0;
    FBodyStartedFlag  := False;    { V8.67 was FBodyLineCount }

    if (FCurrentHost = FHostName) and (FCurrentPort = FPort) and
            (FCurrentProtocol = FProtocol) and (not FCloseReq) then begin      { SAE 01/06/04 }
        Inc (FLocationChangeCurCount) ;
        if FLocationChangeCurCount > FLocationChangeMaxCount then begin
            AllowMoreRelocations := false;
            if Assigned (FOnLocationChangeExceeded) then
                FOnLocationChangeExceeded(Self, FLocationChangeCurCount,
                                                         AllowMoreRelocations) ;
            if not AllowMoreRelocations then begin
                SetReady;
                exit;
            end ;
        end;

        { No need to disconnect }
        { Trigger the location changed event  27/04/2003 }
        TriggerLocationChange;  { V8.61 }
        SaveLoc := FLocation;  { 01/05/03 }
        SavedStatus := FStatusCode;  { V8.37 keep if before it's lost }
        InternalClear;   { clears most header vars }
        FLocation := SaveLoc;
        FDocName  := FPath;
        AdjustDocName;
        { When relocation occurs doing a POST, new relocated page }
        { has to be GET.  01/05/03                                }
        { if FRequestType = httpPOST then }
        { angus V8.07  unless a 307 or 308 POST which must not revert to GET }
        {if (FRequestType = httpPOST) and not ((FStatusCode = 307) or (FStatusCode = 308)) then }
        { angus V8.10 - try and match how Chrome and Firefox handle POST relocation }
        { angus V8.37 - last fix failed 302 because status had been cleared }
        if ((SavedStatus=303) and (FRequestType <> httpHEAD)) or
              ((FRequestType = httpPOST) and ((SavedStatus=301) or (SavedStatus=302))) then
            FRequestType  := httpGET;
        { Must clear what we already received }
        CleanupRcvdStream; {11/11/04}
        CleanupSendStream;
        LoginDelayed;
    end
    else begin
        FCtrlSocket.OnSessionClosed := LocationSessionClosed;
        FCtrlSocket.CloseDelayed;
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure THttpCli.CleanupRcvdStream;
begin
    { What we are received must be removed }
{$IFDEF UseContentCoding}
    if Assigned(FRcvdStream) and (FRcvdStream.Size <> FRcvdStreamStartSize) then
{$IFNDEF COMPILER3_UP}
  { V8.67 removed ancient code }
{$ELSE}
        FRcvdStream.Size := FRcvdStreamStartSize;
{$ENDIF}
{$ELSE}
    if Assigned(FRcvdStream) and (FRcvdCount > 0) then
{$IFNDEF COMPILER3_UP}
  { V8.67 removed ancient code }
{$ELSE}
        FRcvdStream.Size := FRcvdStream.Size - FRcvdCount;
{$ENDIF}
{$ENDIF}
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure THttpCli.CleanupSendStream;
begin
    { Reset the start position of the stream }
    if Assigned(FSendStream) and (FSentCount > 0) then
    {    FSendStream.Seek(-FSentCount, soFromCurrent);  }
        FSendStream.Position := FSendStream.Position - FSentCount;   { V8.67 better }
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{$IFDEF UseNTLMAuthentication}
procedure THttpCli.StartAuthNTLM;
var
//    I : Integer;
    WAI: Integer;
begin
    if FAuthNTLMState = ntlmNone then begin
{$IFNDEF NO_DEBUG_LOG}
        if CheckLogOptions(loProtSpecInfo) then  { V1.91 } { replaces $IFDEF DEBUG_OUTPUT  }
            DebugLog(loProtSpecInfo, 'Starting NTLM authentication');
{$ENDIF}
        FAuthNTLMState    := ntlmMsg1;
        FAuthBasicState   := basicNone; { Other authentication must be cleared }

        { [rawbite 31.08.2004 Connection controll]                       }
        { if request version is 1.0 we must tell the server that we want }
        { to keep the connection or NTLM will not work                   }
        if (FRequestVer = '1.0') or (FResponseVer = '1.0') or  // <== 12/29/05 AG
           (FResponseVer = '') then                            // <== 12/29/05 AG
            FCurrConnection := 'Keep-alive';

        LoginDelayed;
    end
    else if FAuthNTLMState = ntlmMsg1 then begin
     {   I := FDoAuthor.Count - 1;
        while I >= 0 do begin
            if CompareText(Copy(FDoAuthor.Strings[I], 1, 4), 'NTLM') = 0 then
                Break;
            Dec(I);
        end;
        if I < 0 then
            Exit;
        FNTLMMsg2Info     := NtlmGetMessage2(Copy(FDoAuthor.Strings[I], 6, 1000));   }

        WAI := FindAuthType(httpAuthNtlm);   { V8.69 find authorisation information for type }
        if WAI < 0 then Exit;
        FNTLMMsg2Info     := NtlmGetMessage2(Copy(WWWAuthInfos[WAI].Header, 6, 1000));
        FAuthNTLMState    := ntlmMsg3;
        LoginDelayed;
    end
    else if FAuthNTLMState = ntlmMsg3 then begin
        FDoAuthor.Clear;
        FAuthNTLMState := ntlmNone;
        { We comes here when NTLM has failed }
        { so we trigger the end request      }
        PostMessage(Handle, FMsg_WM_HTTP_REQUEST_DONE, 0, 0);
    end
    else
        raise EHttpException.Create('Unexpected AuthNTLMState', httperrInvalidAuthState);

    end;
{$ENDIF}


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{$IFDEF UseNTLMAuthentication}
procedure THttpCli.StartProxyAuthNTLM;
var
//    I : Integer;
    WAI: Integer;
begin
    if FProxyAuthNTLMState = ntlmNone then begin
{$IFNDEF NO_DEBUG_LOG}
        if CheckLogOptions(loProtSpecInfo) then  { V1.91 } { replaces $IFDEF DEBUG_OUTPUT  }
                DebugLog(loProtSpecInfo, 'Starting Proxy NTLM authentication');
{$ENDIF}
        FProxyAuthNTLMState := ntlmMsg1;
        FProxyAuthBasicState := basicNone; { Other authentication must be cleared }
{$IFDEF UseDigestAuthentication}
        FProxyAuthDigestState := digestNone;
{$ENDIF}
        { [rawbite 31.08.2004 Connection controll]                       }
        { if request version is 1.0 we must tell the server that we want }
        { to keep the connection or NTLM will not work                   }
        if (FRequestVer = '1.0') or (FResponseVer = '1.0') or  // <== 12/29/05 AG
           (FResponseVer = '') then                            // <== 12/29/05 AG
            FCurrProxyConnection := 'Keep-alive';

        LoginDelayed;
    end
    else if FProxyAuthNTLMState = ntlmMsg1 then begin
     {   I := FDoAuthor.Count - 1;
        while I >= 0 do begin
            if CompareText(Copy(FDoAuthor.Strings[I], 1, 4), 'NTLM') = 0 then
                Break;
            Dec(I);
        end;
        if I < 0 then
            Exit;
        if assigned (FAuthNtlmSession) then                                                                             // V8.61
            FAuthNtlmSession.NtlmMessage := Base64Decode (Copy(FDoAuthor.Strings[I], 6, Length (FDoAuthor.Strings[I]))) // V8.61
        else                                                                                                            // V8.61
            FProxyNTLMMsg2Info  := NtlmGetMessage2(Copy(FDoAuthor.Strings[I], 6, 1000));   }

         WAI := FindAuthType(httpAuthNtlm);   { V8.69 find authorisation information for type }
        if WAI < 0 then Exit;
         if assigned (FAuthNtlmSession) then                                                                             // V8.61
            FAuthNtlmSession.NtlmMessage := Base64Decode (Copy(WWWAuthInfos[WAI].Header, 6, Length (WWWAuthInfos[WAI].Header))) // V8.61
        else                                                                                                            // V8.61
            FProxyNTLMMsg2Info := NtlmGetMessage2(Copy(WWWAuthInfos[WAI].Header, 6, 1000));
        FProxyAuthNTLMState := ntlmMsg3;
        LoginDelayed;
    end
    else if FProxyAuthNTLMState = ntlmMsg3 then begin
        FDoAuthor.Clear;
        FProxyAuthNTLMState := ntlmNone;
        { We comes here when NTLM has failed }
        { so we trigger the end request      }
        PostMessage(Handle, FMsg_WM_HTTP_REQUEST_DONE, 0, 0);
    end
    else
        raise EHttpException.Create('Unexpected ProxyAuthNTLMState', httperrInvalidAuthState);
end;
{$ENDIF}


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure THttpCli.StartAuthBasic;
begin
    if FAuthBasicState = basicNone then begin
{$IFNDEF NO_DEBUG_LOG}
        if CheckLogOptions(loProtSpecInfo) then  { V1.91 } { replaces $IFDEF DEBUG_OUTPUT  }
            DebugLog(loProtSpecInfo, 'Starting Basic authentication');
{$ENDIF}
        FAuthBasicState   := basicMsg1;
{$IFDEF UseNTLMAuthentication}
        FAuthNTLMState    := ntlmNone; { Other authentication must be cleared }
{$ENDIF}
{$IFDEF UseDigestAuthentication}
        FAuthDigestState  := digestNone;
{$ENDIF}
        LoginDelayed;
    end
    else if FAuthBasicState = basicMsg1 then begin
        FDoAuthor.Clear;
        FAuthBasicState := basicNone;
        { We comes here when Basic has failed }
        { so we trigger the end request       }
        PostMessage(Handle, FMsg_WM_HTTP_REQUEST_DONE, 0, 0);
    end
    else
        raise EHttpException.Create('Unexpected AuthBasicState', httperrInvalidAuthState);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure THttpCli.StartProxyAuthBasic;
begin
    if FProxyAuthBasicState = basicNone then begin
{$IFNDEF NO_DEBUG_LOG}
        if CheckLogOptions(loProtSpecInfo) then  { V1.91 } { replaces $IFDEF DEBUG_OUTPUT  }
            DebugLog(loProtSpecInfo, 'Starting Proxy Basic authentication');
{$ENDIF}
        FProxyAuthBasicState := basicMsg1;
{$IFDEF UseNTLMAuthentication}
        FProxyAuthNTLMState  := ntlmNone; { Other authentication must be cleared }
{$ENDIF}
{$IFDEF UseDigestAuthentication}
        FProxyAuthDigestState := digestNone;
{$ENDIF}
        LoginDelayed;
    end
    else if FProxyAuthBasicState = basicMsg1 then begin
        FDoAuthor.Clear;
        FProxyAuthBasicState := basicNone;
        { We comes here when Basic has failed }
        { so we trigger the end request       }
        PostMessage(Handle, FMsg_WM_HTTP_REQUEST_DONE, 0, 0);
    end
    else
        raise EHttpException.Create('Unexpected ProxyAuthBasicState', httperrInvalidAuthState);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function THttpCli.GetBasicAuthorizationHeader(
  const HttpMethod: String; ProxyAuth: Boolean): String;
begin
    if ProxyAuth then
        Result := 'Proxy-Authorization: Basic ' +
                  EncodeStr(encBase64, FProxyUsername + ':' + FProxyPassword)
    else
        Result := 'Authorization: Basic ' +
                  EncodeStr(encBase64, FCurrUsername + ':' + FCurrPassword);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{$IFDEF UseDigestAuthentication}
procedure THttpCli.ElaborateDigestAuth;
begin
    { if you place this code in GetHeaderLineNext, not each time will be }
    { called ...                                                         }
    if (FAuthDigestState = digestMsg1) and (FStatusCode <> 401) and
       (FStatusCode <> 407) then
        FAuthDigestState := digestDone
    else if (FAuthDigestState = digestDone) and (FStatusCode = 401) then
        FAuthDigestState := digestNone;

    if (FProxyAuthDigestState = digestMsg1) and (FStatusCode <> 407) then
        FProxyAuthDigestState := digestDone
    else if (FProxyAuthDigestState = digestDone) and (FStatusCode = 407) then begin
        { if we lost proxy authenticated line, most probaly we lost also }
        { the authenticated line of Proxy to HTTP server, so reset the   }
        { Digest state of HTTP also to none                              }
        FProxyAuthDigestState := digestNone;
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function THttpCli.PrepareDigestAuth(var FlgClean : Boolean) : Boolean;
var
//    I : Integer;
    WAI: Integer;
begin
    { this flag can tell if we proceed with OnRequestDone or will try    }
    { to authenticate                                                    }
    Result := FALSE;
    if (httpoNoDigestAuth in FOptions) and
       (((FStatusCode = 401) and (FServerAuth in [httpAuthDigest, httpAuthDigest2])) or   { V8.69 SHA-256 }
       ((FStatusCode = 407) and (FProxyAuth in [httpAuthDigest, httpAuthDigest2]))) then
        Exit;
    if (FStatusCode = 401) and (FDoAuthor.Count > 0) and
    {$IFDEF UseNTLMAuthentication}
       (FAuthNTLMState = ntlmNone) and
    {$ENDIF}
       (FAuthBasicState = basicNone) and
       (FCurrUserName <> '') and (FCurrPassword <> '') then begin
        { We can handle Digest Access Authentication }
   {     for I := FDoAuthor.Count - 1 downto 0 do begin
            if CompareText(Copy(FDoAuthor.Strings[I], 1, 6),
                          'Digest') = 0 then begin
                Result := TRUE;
                if Assigned(FOnBeforeAuth) then
                    FOnBeforeAuth(Self, httpAuthDigest, FALSE, FDoAuthor.Strings[I], Result);
                if Result then begin
                    AuthDigestParseChallenge(Copy(FDoAuthor.Strings[I], 8, 1000), FAuthDigestInfo);
                    if AuthDigestValidateResponse(FAuthDigestInfo) then begin
                        StartAuthDigest;
                        if FAuthDigestState = digestMsg1 then
                            FlgClean := True;
                        Break;
                    end
                    else
                        Result := FALSE;
                end;
            end;
        end;   }

     { V8.69 used parsed headers from WWWAuthInfos instead of enumerating FDoAuthor.Strings }
     { also supports both MD5 and SHA-256 hash algorithms }
        WAI := FindAuthType(FServerAuth);
        if WAI >= 0 then begin
            Result := TRUE;
            if Assigned(FOnBeforeAuth) then
                FOnBeforeAuth(Self, WWWAuthInfos[WAI].AuthType, FALSE, WWWAuthInfos[WAI].Header, Result);
            if Result then begin
                AuthDigestParseChallenge(Copy(WWWAuthInfos[WAI].Header, 8, 1000), FAuthDigestInfo);
                if AuthDigestValidateResponse(FAuthDigestInfo) then begin
                    StartAuthDigest;
                    if FAuthDigestState = digestMsg1 then
                        FlgClean := True;
                end
                else
                    Result := FALSE;
            end;
        end;
    end
    else if (FStatusCode = 407) and (FDoAuthor.Count > 0) and
        {$IFDEF UseNTLMAuthentication}
            (FProxyAuthNTLMState = ntlmNone) and
        {$ENDIF}
            (FProxyAuthBasicState = basicNone) and
            (FProxyUsername <> '') and (FProxyPassword <> '') then begin
        { We can handle Digest Access Authentication }
   {     for I := FDoAuthor.Count - 1 downto 0 do begin
            if CompareText(Copy(FDoAuthor.Strings[I], 1, 6),
                          'Digest') = 0 then begin
                Result := TRUE;
                if Assigned(FOnBeforeAuth) then
                    FOnBeforeAuth(Self, httpAuthDigest, TRUE,
                                  FDoAuthor.Strings[I], Result);
                if Result then begin
                    AuthDigestParseChallenge(Copy(FDoAuthor.Strings[I], 8, 1000), FAuthDigestProxyInfo);
                    if AuthDigestValidateResponse(FAuthDigestProxyInfo) then begin
                        StartProxyAuthDigest;
                        if FProxyAuthDigestState = digestMsg1 then
                            FlgClean := True;
                        Break;
                    end
                    else
                        Result := FALSE;
                end;
            end;
        end;  }
     { V8.69 used parsed headers from WWWAuthInfos instead of enumerating FDoAuthor.Strings }
     { also supports both MD5 and SHA-256 hash algorithms }
        WAI := FindAuthType(FProxyAuth);
        if WAI >= 0 then begin
            Result := TRUE;
            if Assigned(FOnBeforeAuth) then
                FOnBeforeAuth(Self, WWWAuthInfos[WAI].AuthType, TRUE, WWWAuthInfos[WAI].Header, Result);
            if Result then begin
                AuthDigestParseChallenge(Copy(WWWAuthInfos[WAI].Header, 8, 1000), FAuthDigestProxyInfo);
                if AuthDigestValidateResponse(FAuthDigestProxyInfo) then begin
                    StartProxyAuthDigest;
                    if FProxyAuthDigestState = digestMsg1 then
                        FlgClean := True;
                end
                else
                    Result := FALSE;
            end;
        end;
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function THttpCli.GetDigestAuthorizationHeader(
  const HttpMethod: String; ProxyAuth: Boolean): String;
var
    Proto, User, Pass, Host, Port, Uri : String;
begin
    { It's probably faster to use a field FAuthDigestUri which   }
    { is set at some other places when ParseUrl is called anyway }
    ParseURL(FPath, Proto, User, Pass, Host, Port, Uri);

    if ProxyAuth then begin
        Inc(FAuthDigestProxyInfo.Nc);
        Result := 'Proxy-Authorization: Digest ' +
                  AuthDigestGenerateRequest(FProxyUserName,
                                            FProxyPassword,
                                            HttpMethod,
                                            Uri,
                                            FAuthDigestEntityHash,
                                            FAuthDigestProxyInfo);
    end
    else begin
        FAuthDigestInfo.Nc := 1;
        Result := 'Authorization: Digest ' +
                  AuthDigestGenerateRequest(FCurrUserName,
                                            FCurrPassword,
                                            HttpMethod,
                                            Uri,
                                            FAuthDigestEntityHash,
                                            FAuthDigestInfo);
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure THttpCli.StartAuthDigest;
begin
    if FAuthDigestState = digestNone then begin
    {$IFNDEF NO_DEBUG_LOG}
        if CheckLogOptions(loProtSpecInfo) then
            DebugLog(loProtSpecInfo, 'Starting Digest authentication');
    {$ENDIF}
        FAuthDigestState  := digestMsg1;
    {$IFDEF UseNTLMAuthentication}
        FAuthNTLMState    := ntlmNone; { Other authentication must be cleared }
    {$ENDIF}
        FAuthBasicState   := basicNone;
        LoginDelayed;
    end
    else if FAuthDigestState = digestMsg1 then begin
        FDoAuthor.Clear;
        FAuthDigestState := digestNone;
        { We comes here when Basic has failed }
        { so we trigger the end request       }
        PostMessage(Handle, FMsg_WM_HTTP_REQUEST_DONE, 0, 0);
    end
    else
        raise EHttpException.Create('Unexpected AuthDigestState', httperrInvalidAuthState);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure THttpCli.StartProxyAuthDigest;
begin
    if FProxyAuthDigestState = digestNone then begin
    {$IFNDEF NO_DEBUG_LOG}
        if CheckLogOptions(loProtSpecInfo) then
            DebugLog(loProtSpecInfo, 'Starting Proxy Digest authentication');
    {$ENDIF}
        FProxyAuthDigestState := digestMsg1;
    {$IFDEF UseNTLMAuthentication}
        FProxyAuthNTLMState  := ntlmNone; { Other authentication must be cleared }
    {$ENDIF}
        FProxyAuthBasicState := basicNone;
        LoginDelayed;
    end
    else if FProxyAuthDigestState = digestMsg1 then begin
        FDoAuthor.Clear;
        FProxyAuthDigestState := digestNone;
        { We come here when Digest has failed }
        { so we trigger the end request       }
        PostMessage(Handle, FMsg_WM_HTTP_REQUEST_DONE, 0, 0);
    end
    else
        raise EHttpException.Create('Unexpected ProxyAuthDigestState',
                                    httperrInvalidAuthState);
end;
{$ENDIF UseDigestAuthentication}

{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{$IFDEF USE_SSL}
procedure THttpCli.TransferSslHandshakeDone(         { V8.61 }
    Sender         : TObject;
    ErrCode        : Word;
    PeerCert       : TX509Base;
    var Disconnect : Boolean);
begin
    if Assigned(TSslHttpCli(Self).FOnSslHandshakeDone) then begin
        FReasonPhrase := '';  { V8.12 }
        TSslHttpCli(Self).FOnSslHandshakeDone(Self, ErrCode, PeerCert, Disconnect);
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure THttpCli.SslHandshakeDone(
    Sender         : TObject;
    ErrCode        : Word;
    PeerCert       : TX509Base;
    var Disconnect : Boolean);

    procedure InitStartSend;      { V8.71 commonize code }
    begin
    {$IFDEF UseNTLMAuthentication}
        if not ((FAuthNTLMState = ntlmMsg1) or (FProxyAuthNTLMState = ntlmMsg1)) then begin
            TriggerSendBegin;
            FAllowedToSend := TRUE;
            FDelaySetReady := FALSE;     { 09/26/08 ML }
            SocketDataSent(FCtrlSocket, 0);
        end;
    {$ELSE}
        TriggerSendBegin;
        FAllowedToSend := TRUE;
        FDelaySetReady := FALSE;     { 09/26/08 ML }
        SocketDataSent(FCtrlSocket, 0);
    {$ENDIF}
    end;

begin
    TransferSslHandshakeDone(Self, ErrCode, PeerCert, Disconnect);  { V8.61 }
    if (ErrCode <> 0) or Disconnect then begin
        FStatusCode       := 404;
        if FReasonPhrase = '' then begin  { V8.12 may have set better reason in event }
         //   if Disconnect then  { V8.55 we always disconnect failure... }
         //       FReasonPhrase := 'SSL custom abort'
         //   else
                FReasonPhrase := 'SSL handshake failed - ' + CtrlSocket.SslHandshakeRespMsg;  { V8.12 }
        end;
        FRequestDoneError := httperrSslHandShake;  { V8.68 never used httperrAborted }
        FConnected        := False;
        Exit;
    end;
    if not FProxyConnected then
        Exit;
    try
        FNext := GetHeaderLineNext;
        StateChange(httpWaitingHeader);

        case FRequestType of
        httpPOST:
            begin
                SendRequest('POST', FRequestVer);
                InitStartSend;                    { V8.71 commonize code }
            end;
        httpPUT:
            begin
                SendRequest('PUT', FRequestVer);
                InitStartSend;                    { V8.71 commonize code }
            end;
        httpPATCH:    { V8.06 }
            begin
                SendRequest('PATCH', FRequestVer);
                InitStartSend;                    { V8.71 commonize code }
            end;
        httpDELETE:
            begin
                SendRequest('DELETE', FRequestVer);
              { V8.71 DELETE can have a content body }
                if (httpoGetContent in FOptions) and Assigned(SendStream) then
                    InitStartSend;                    { V8.71 commonize code }
            end;
        httpOPTIONS:
            begin
                SendRequest('OPTIONS', FRequestVer);
            end;
        httpTRACE:
            begin
                SendRequest('TRACE', FRequestVer);
            end;
        httpHEAD:
            begin
                SendRequest('HEAD', FRequestVer);
            end;
        httpGET:
            begin
                SendRequest('GET', FRequestVer);
              { V8.71 GET can have a content body }
                if (httpoGetContent in FOptions) and Assigned(SendStream) then
                    InitStartSend;                    { V8.71 commonize code }
            end;
        end;
    except
        Logout;
    end;
end;
{$ENDIF}


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure THttpCli.SocketDataSent(Sender : TObject; ErrCode : Word);
var
    Len : Integer;
begin
    if not FAllowedToSend then
        Exit;

    if Length(FSendBuffer) = 0 then
        SetLength(FSendBuffer, 8192);
    Len := FSendStream.Read(FSendBuffer[0], Length(FSendBuffer));
    if Len <= 0 then begin
        FAllowedToSend := FALSE;
        TriggerSendEnd;
        if FDelaySetReady then begin     { 09/26/08 ML }
          FDelaySetReady := FALSE;       { 09/26/08 ML }
          SetReady;                      { 09/26/08 ML }
        end;                             { 09/26/08 ML }
        Exit;
    end;

    if Len > 0 then begin
        FSentCount := FSentCount + Len;
        TriggerSendData(@FSendBuffer[0], Len);
        FCtrlSocket.Send(@FSendBuffer[0], Len);
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ This will start the Get process and wait until terminated (blocking)      }
procedure THttpCli.Get;
begin
    FLocationChangeCurCount := 0 ;  {  V1.90 }
    DoRequestSync(httpGet);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ This will start the Head process and wait until terminated (blocking)     }
procedure THttpCli.Head;
begin
    FLocationChangeCurCount := 0 ;  {  V1.90 }
    DoRequestSync(httpHEAD);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ This will start the Delete process and wait until terminated (blocking)   }
procedure THttpCli.Del;
begin
    FLocationChangeCurCount := 0 ;
    DoRequestSync(httpDELETE);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ This will start the Post process and wait until terminated (blocking)     }
procedure THttpCli.Post;
begin
    FLocationChangeCurCount := 0 ;  {  V1.90 }
    DoRequestSync(httpPOST);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ This will start the Put process and wait until terminated (blocking)      }
procedure THttpCli.Put;
begin
    FLocationChangeCurCount := 0 ;  {  V1.90 }
    DoRequestSync(httpPUT);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ This will start the Patch process and wait until terminated (blocking)      }
procedure THttpCli.Patch;   { V8.06 }
begin
    FLocationChangeCurCount := 0 ;
    DoRequestSync(httpPatch);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ This will start the Options process and wait until terminated (blocking)      }
procedure THttpCli.OptionsSync;     { V8.09 }
begin
    FLocationChangeCurCount := 0 ;
    DoRequestSync(httpOptions);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ This will start the Trace process and wait until terminated (blocking)      }
procedure THttpCli.Trace;     { V8.09 }
begin
    FLocationChangeCurCount := 0 ;
    DoRequestSync(httpTrace);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ This will start the Close process and wait until terminated (blocking)    }
procedure THttpCli.Close;
begin
    DoRequestSync(httpCLOSE);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ This will start the get process and returns immediately (non blocking)    }
procedure THttpCli.GetAsync;
begin
    FLocationChangeCurCount := 0 ;  {  V1.90 }
    DoRequestASync(httpGet);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ This will start the head process and returns immediately (non blocking)   }
procedure THttpCli.HeadAsync;
begin
    FLocationChangeCurCount := 0 ;  {  V1.90 }
    DoRequestASync(httpHEAD);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ This will start the delete process and returns immediately (non blocking) }
procedure THttpCli.DelAsync;
begin
    FLocationChangeCurCount := 0 ;
    DoRequestASync(httpDELETE);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ This will start the post process and returns immediately (non blocking)   }
procedure THttpCli.PostAsync;
begin
    FLocationChangeCurCount := 0 ;  {  V1.90 }
    DoRequestASync(httpPOST);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ This will start the put process and returns immediately (non blocking)    }
procedure THttpCli.PutAsync;
begin
    FLocationChangeCurCount := 0 ;  {  V1.90 }
    DoRequestASync(httpPUT);
end;

{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ This will start the patch process and returns immediately (non blocking)    }
procedure THttpCli.PatchAsync;   { V8.06 }
begin
    FLocationChangeCurCount := 0 ;
    DoRequestASync(httpPatch);
end;

{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ This will start the options process and returns immediately (non blocking)    }
procedure THttpCli.OptionsAsync;  { V8.09 }
begin
    FLocationChangeCurCount := 0 ;
    DoRequestASync(httpOptions);
end;

{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ This will start the trace process and returns immediately (non blocking)    }
procedure THttpCli.TraceAsync;   { V8.09 }
begin
    FLocationChangeCurCount := 0 ;
    DoRequestASync(httpTrace);
end;

{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ This will start the close process and returns immediately (non blocking)  }
procedure THttpCli.CloseAsync;
begin
    DoRequestASync(httpCLOSE);
end;

{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ This will start a request returns immediately (non blocking)  }
procedure THttpCli.RequestAsync(Rq :THttpRequest);                               { V8.69 }
begin
    DoRequestASync(Rq);
end;

{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ This will start a request and wait until terminated (blocking)    }
procedure THttpCli.RequestSync(Rq :THttpRequest);                                { V8.69 }
begin
    DoRequestSync(Rq);
end;

{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function GetBaseUrl(const Url : String) : String;
var
    I : Integer;
begin
    I := 1;
    while (I <= Length(Url)) and (Url[I] <> '?') do
        Inc(I);
    Dec(I);
    while (I > 0) and (not (AnsiChar(Url[I]) in ['/', ':'])) do
        Dec(I);
    Result := Copy(Url, 1, I);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure THttpCli.SetRequestVer(const Ver : String);
begin
    if FRequestVer <> Ver then begin
        if (Ver = '1.0') or (Ver = '1.1') then
            FRequestVer := Ver
        else
            raise EHttpException.Create('Insupported HTTP version',
                                        httperrVersion);
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function EncodeLine(
    Encoding : THttpEncoding;
    SrcData  : PAnsiChar;
    Size     : Integer) : AnsiString;
var
    Offset : Integer;
    Pos1   : Integer;
    Pos2   : Integer;
    I      : Integer;
begin
    //SetLength(Result, Size * 4 div 3 + 4);
    //FillChar(Result[1], Size * 4 div 3 + 2, #0);
    Result := StringOfChar(AnsiChar(#0), Size * 4 div 3 + 4);
    if Encoding = encUUEncode then begin
        Result[1] := AnsiChar(((Size - 1) and $3f) + $21);
        Size      := ((Size + 2) div 3) * 3;
    end;
    Offset := 2;
    Pos1   := 0;
    Pos2   := 0;
    case Encoding of
        encUUEncode:        Pos2 := 2;
        encBase64, encMime: Pos2 := 1;
    end;
    Result[Pos2] := #0;

    while Pos1 < Size do begin
        if Offset > 0 then begin
            Result[Pos2] := AnsiChar(ord(Result[Pos2]) or
                                 ((ord(SrcData[Pos1]) and
                                  ($3f shl Offset)) shr Offset));
            Offset := Offset - 6;
            Inc(Pos2);
            Result[Pos2] := #0;
        end
        else if Offset < 0 then begin
            Offset := Abs(Offset);
            Result[Pos2] := AnsiChar(ord(Result[Pos2]) or
                                 ((ord(SrcData[Pos1]) and
                                  ($3f shr Offset)) shl Offset));
            Offset := 8 - Offset;
            Inc(Pos1);
        end
        else begin
            Result[Pos2] := AnsiChar(ord(Result[Pos2]) or
                                 ((ord(SrcData[Pos1]) and $3f)));
            Inc(Pos2);
            Inc(Pos1);
            Result[Pos2] := #0;
            Offset    := 2;
        end;
    end;

    case Encoding of
    encUUEncode:
        begin
            if Offset = 2 then
                Dec(Pos2);
            for i := 2 to Pos2 do
                Result[i] := bin2uue[ord(Result[i])+1];
        end;
    encBase64, encMime:
        begin
            if Offset = 2 then
                Dec(Pos2);
            for i := 1 to Pos2 do
                Result[i] := bin2b64[ord(Result[i])+1];
            while (Pos2 and 3) <> 0  do begin
                Inc(Pos2);
                Result[Pos2] := '=';
            end;
        end;
    end;
    SetLength(Result, Pos2);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function EncodeStr(
    Encoding    : THttpEncoding;
    const Value : RawByteString) : RawByteString;
begin
    Result := EncodeLine(Encoding, PAnsiChar(Value), Length(Value));
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function EncodeStr(
    Encoding    : THttpEncoding;
    const Value : UnicodeString;
    ACodePage   : LongWord = CP_ACP ) : UnicodeString;
var
    AStr : AnsiString;
begin
    AStr := UnicodeToAnsi(Value, ACodePage);
    Result := String(EncodeLine(Encoding, PAnsiChar(AStr), Length(AStr)));
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{$IFDEF UseNTLMAuthentication}
function THttpCli.GetNTLMMessage1(const ForProxy: Boolean): String;
begin
    { Result := FNTLM.GetMessage1(FNTLMHost, FNTLMDomain);            }
    { it is very common not to send domain and workstation strings on }
    { the first message                                               }
    if ForProxy then begin
        if assigned (FAuthNtlmSession) then                  // V8.61
            Result := 'Proxy-Authorization: NTLM ' +
                      FAuthNtlmSession.GetUserCredentials    // V8.61
        else
        Result := 'Proxy-Authorization: NTLM ' +
                  NtlmGetMessage1('', '', FLmCompatLevel)  { V7.25 }
    end
    else
        Result := 'Authorization: NTLM ' +
                  NtlmGetMessage1('', '', FLmCompatLevel); { V7.25 }
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function THttpCli.GetNTLMMessage3(const HttpMethod: String;
  const ForProxy: Boolean): String;
var
    Hostname : String;
    LDomain, LUser: String;
begin
    { get local hostname }
    try
        Hostname := String(LocalHostName);
    except
        Hostname := '';
    end;

    { hostname is the local hostname }
    if ForProxy then begin
        if assigned (FAuthNtlmSession) then                   // V8.61
            Result := 'Proxy-Authorization: NTLM ' +
                      FAuthNtlmSession.GetUserCredentials     // V8.61
        else begin
            NtlmParseUserCode(FProxyUsername, LDomain, LUser);
            Result := 'Proxy-Authorization: NTLM ' +
                  NtlmGetMessage3(LDomain,
                                  Hostname,
                                  LUser,
                                  FProxyPassword,
                                  FProxyNTLMMsg2Info, { V7.25 }
                                  CP_ACP,
                                  FLmCompatLevel);    { V7.25 }
        end
    end
    else begin
        NtlmParseUserCode(FCurrUsername, LDomain, LUser);
        Result := 'Authorization: NTLM ' +
                  NtlmGetMessage3(LDomain,
                                  Hostname,
                                  LUser, FCurrPassword,
                                  FNTLMMsg2Info,   { V7.25 }
                                  CP_ACP,
                                  FLmCompatLevel); { V7.25 }
    end;
end;
{$ENDIF}


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{$IFDEF UseContentCoding}
function THttpCli.GetOptions: THttpCliOptions;
begin
    if FContentCodingHnd.Enabled then
        Include(FOptions, httpoEnableContentCoding)
    else
        Exclude(FOptions, httpoEnableContentCoding);

    if FContentCodingHnd.UseQuality then
        Include(FOptions, httpoUseQuality)
    else
        Exclude(FOptions, httpoUseQuality);

    Result := FOptions;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure THttpCli.SetOptions(const Value : THttpCliOptions);
begin
    FOptions := Value;
    FContentCodingHnd.Enabled := (httpoEnableContentCoding in Value);
    FContentCodingHnd.UseQuality := (httpoUseQuality in Value);
end;
{$ENDIF}


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{$IFNDEF NO_DEBUG_LOG}
function THttpCli.GetIcsLogger: TIcsLogger;                            { V1.91 }
begin
    Result := FCtrlSocket.IcsLogger;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure THttpCli.SetIcsLogger(const Value: TIcsLogger);              { V1.91 }
begin
    FCtrlSocket.IcsLogger := Value;
end;



{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function THttpCli.CheckLogOptions(const LogOption: TLogOption): Boolean;  { V1.91 }
begin
    Result := Assigned(IcsLogger) and (LogOption in IcsLogger.LogOptions);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure THttpCli.DebugLog(LogOption: TLogOption; const Msg: string);    { V1.91 }
begin
    if Assigned(IcsLogger) then
        IcsLogger.DoDebugLog(Self, LogOption, Msg);
end;
{$ENDIF}

{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure THttpCli.ThreadAttach;
begin
    inherited ThreadAttach;
    FCtrlSocket.ThreadAttach;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure THttpCli.ThreadDetach;
begin
    inherited ThreadDetach;
    FCtrlSocket.ThreadDetach;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure THttpCli.CheckDelaySetReady;                        { 09/26/08 ML }
begin
    if FAllowedToSend and ((FStatusCode = 401) or (FStatusCode = 407)) then
        FDelaySetReady := TRUE
    else
        //SetReady;
        PostMessage(Handle, FMsg_WM_HTTP_SET_READY, 0, 0);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ You must define USE_SSL so that SSL code is included in the component.    }
{ Either in OverbyteIcsDefs.inc or in the project/package options.          }
{$IFDEF USE_SSL}
{$IFDEF VER80}
    Bomb('This unit requires a 32 bit compiler !');
{$ENDIF}
{$B-}                                 { Enable partial boolean evaluation   }
{$T-}                                 { Untyped pointers                    }
{$X+}                                 { Enable extended syntax              }
{$H+}                                 { Use long strings                    }
{$J+}                                 { Allow typed constant to be modified }
{ If you use Delphi 7, you may wants to disable warnings for unsafe type,   }
{ unsafe code and unsafe typecast in the project options. Those warning are }
{ intended for .NET programs. You may also want to turn off deprecated      }
{ symbol and platform symbol warnings.                                      }


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TSslHttpCli.CreateSocket;
begin
    FCtrlSocket           := TSslWSocket.Create(nil);
    FCtrlSocket.SslEnable := TRUE;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TSslHttpCli.DoBeforeConnect;
begin
    inherited DoBeforeConnect;
   { V8.11 needed for SNI support, V8.48 was FHostName which failed for proxies }
    FCtrlSocket.SslServerName       := FTargetHost;
    FCtrlSocket.OnSslVerifyPeer     := TransferSslVerifyPeer;
    FCtrlSocket.OnSslCliGetSession  := TransferSslCliGetSession;
    FCtrlSocket.OnSslCliNewSession  := TransferSslCliNewSession;
    FCtrlSocket.OnSslHandshakeDone  := SslHandshakeDone;
    FCtrlSocket.OnSslCliCertRequest := TransferSslCliCertRequest;
    if FProxy <> '' then
        FCtrlSocket.SslEnable := FALSE
    else
        FCtrlSocket.SslEnable := IsSSLProtocol(FProtocol);   { V8.71 JK }
  { V8.62 set Alpn Protocols in SslCtx }
    if FAlpnProtoList.Count > 0 then
        FCtrlSocket.SslContext.SetSslAlpnProtocols(FAlpnProtoList);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function TSslHttpCli.GetSslContext: TSslContext;
begin
    Result := FCtrlSocket.SslContext
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TSslHttpCli.SetSslContext(Value: TSslContext);
begin
    FCtrlSocket.SslContext := Value;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TSslHttpCli.TransferSslCliCertRequest(
    Sender      : TObject;
    var Cert    : TX509Base);
begin
    if Assigned(FOnSslCliCertRequest) then
        FOnSslCliCertRequest(Self, Cert);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TSslHttpCli.TransferSslVerifyPeer(
    Sender        : TObject;
    var Ok        : Integer;
    Cert          : TX509Base);
begin
    if Assigned(FOnSslVerifyPeer) then
        FOnSslVerifyPeer(Self, Ok, Cert);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TSslHttpCli.TransferSslCliGetSession(Sender: TObject;
    var SslSession: Pointer; var FreeSession: Boolean);
begin
    if Assigned(FOnSslCliGetSession) then
        FOnSslCliGetSession(Self, SslSession, FreeSession);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TSslHttpCli.TransferSslCliNewSession(Sender: TObject;
    SslSession: Pointer; WasReused: Boolean; var IncRefCount: Boolean);
begin
    if Assigned(FOnSslCliNewSession) then
        FOnSslCliNewSession(Self, SslSession, WasReused, IncRefCount);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
// Just to make UI easier: parse a semi-colon delimited texte string with
// a list of hosts and build the FSslAcceptableHosts list.
procedure TSslHttpCli.SetAcceptableHostsList(
    const SemiColonSeparatedList : String);
var
    Host : String;
    Buf  : String;
    I    : Integer;
begin
    SslAcceptableHosts.Clear;
    Buf := SemiColonSeparatedList;
    while TRUE do begin
        I := Pos(';', Buf);
        if I > 0 then begin
            Host := Trim(Copy(Buf, 1, I - 1));
            if Host > '' then
                SslAcceptableHosts.Add(Host);
            Delete(Buf, 1, I);
        end
        else begin
            Host := Trim(Buf);
            if Host > '' then
                SslAcceptableHosts.Add(Host);
            break;
        end;
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TSslHttpCli.SetSslAcceptableHosts(Value : TStrings);
begin
    if Assigned(FCtrlSocket) then
        FCtrlSocket.SslAcceptableHosts := Value;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function  TSslHttpCli.GetSslAcceptableHosts: TStrings;
begin
    if Assigned(FCtrlSocket) then
        Result := FCtrlSocket.SslAcceptableHosts
    else
        Result := nil;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ V8.62 keep application layer protocols supported, may not be able to set
        it yet since needs SslCtx }
procedure TSslHttpCli.SetAlpnProtocols(ProtoList: TStrings);
begin
    if NOT Assigned(ProtoList) then Exit;
    if FAlpnProtoList.Text <> ProtoList.Text then
        FAlpnProtoList.Assign(ProtoList);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ V8.62 keep application layer protocols supported }
function TSslHttpCli.GetAlpnProtocol: String;
begin
    if Assigned(FCtrlSocket) then
        Result := FCtrlSocket.SslAlpnProto
    else
        Result := '';
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{$ENDIF} // USE_SSL

end.
