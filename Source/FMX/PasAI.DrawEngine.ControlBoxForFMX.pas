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
{ * draw fmx control                                                           * }
{ ****************************************************************************** }
unit PasAI.DrawEngine.ControlBoxForFMX;

{$I ..\PasAI.Define.inc}

interface

uses System.Types, FMX.Controls, PasAI.DrawEngine, PasAI.Geometry2D, PasAI.Geometry3D;

procedure DrawChildrenControl(WorkCtrl: TControl; DrawEng: TDrawEngine; ctrl: TControl; COLOR: TDEColor; LineWidth: TDEFloat);

implementation

procedure DrawChildrenControl(WorkCtrl: TControl; DrawEng: TDrawEngine; ctrl: TControl; COLOR: TDEColor; LineWidth: TDEFloat);
  procedure DrawControlRect(c: TControl);
  var
    r4: TRectf;
    r: TDERect;
  begin
    r4 := c.AbsoluteRect;
    r := MakeRectV2(Make2DPoint(WorkCtrl.AbsoluteToLocal(r4.TopLeft)), Make2DPoint(WorkCtrl.AbsoluteToLocal(r4.BottomRight)));
    DrawEng.DrawBoxInScene(r, COLOR, LineWidth);
  end;

var
  i: Integer;
begin
  for i := 0 to ctrl.ChildrenCount - 1 do
    begin
      if (ctrl.Children[i] is TControl) and (TControl(ctrl.Children[i]).Visible) then
        begin
          DrawChildrenControl(WorkCtrl, DrawEng, TControl(ctrl.Children[i]), COLOR, LineWidth);
          DrawControlRect(TControl(ctrl.Children[i]));
        end;
    end;
end;

end.
