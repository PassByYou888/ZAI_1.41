﻿(*
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
{******************************************************************************}
{                                                                              }
{       Delphi cross platform socket library                                   }
{                                                                              }
{       Copyright (c) 2017 WiNDDRiVER(soulawing@gmail.com)                     }
{                                                                              }
{       Homepage: https://github.com/winddriver/Delphi-Cross-Socket            }
{                                                                              }
{******************************************************************************}
unit PasAI.Linux.epoll;

// winddriver是个喜欢把程序模型写死的家伙，这并不是一个好习惯，cross的代码一旦出问题，非常难改
// 编译符号全局定义可以有效统一和优化参数，建议所有的库，包括用户自己在工程建的库都引用一下全局定义
{$I ..\..\PasAI.Define.inc}

interface

uses
  Posix.Base, Posix.Signal;

const
  EPOLLIN  = $01; { The associated file is available for read(2) operations. }
  EPOLLPRI = $02; { There is urgent data available for read(2) operations. }
  EPOLLOUT = $04; { The associated file is available for write(2) operations. }
  EPOLLERR = $08; { Error condition happened on the associated file descriptor. }
  EPOLLHUP = $10; { Hang up happened on the associated file descriptor. }
  EPOLLONESHOT = $40000000; { Sets the One-Shot behaviour for the associated file descriptor. }
  EPOLLET  = $80000000; { Sets  the  Edge  Triggered  behaviour  for  the  associated file descriptor. }

  { Valid opcodes ( "op" parameter ) to issue to epoll_ctl }
  EPOLL_CTL_ADD = 1;
  EPOLL_CTL_DEL = 2;
  EPOLL_CTL_MOD = 3;

type
  EPoll_Data = record
    case integer of
      0: (ptr: pointer);
      1: (fd: Integer);
      2: (u32: Cardinal);
      3: (u64: UInt64);
  end;
  TEPoll_Data =  Epoll_Data;
  PEPoll_Data = ^Epoll_Data;

  EPoll_Event = {$IFDEF CPUX64}packed {$ENDIF}record
    Events: Cardinal;
    Data  : TEpoll_Data;
  end;

  TEPoll_Event =  Epoll_Event;
  PEpoll_Event = ^Epoll_Event;

{ open an epoll file descriptor }
function epoll_create(size: Integer): Integer; cdecl;
  external libc name _PU + 'epoll_create';
  {$EXTERNALSYM epoll_create}

{ control interface for an epoll descriptor }
function epoll_ctl(epfd, op, fd: Integer; event: pepoll_event): Integer; cdecl;
  external libc name _PU + 'epoll_ctl';
  {$EXTERNALSYM epoll_ctl}

{ wait for an I/O event on an epoll file descriptor }
function epoll_wait(epfd: Integer; events: pepoll_event; maxevents, timeout: Integer): Integer; cdecl;
  external libc name _PU + 'epoll_wait';
  {$EXTERNALSYM epoll_wait}

{ create a file descriptor for event notification }
function eventfd(initval: Cardinal; flags: Integer): Integer; cdecl;
  external libc name _PU + 'eventfd';
  {$EXTERNALSYM eventfd}

implementation

end.
