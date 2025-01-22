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
{ * DrawEngine-box list tool                                                   * }
{ ****************************************************************************** }
unit PasAI.DrawEngine.BoxListTool;

{$DEFINE FPC_DELPHI_MODE}
{$I PasAI.Define.inc}

interface

uses PasAI.Core,
{$IFDEF FPC}
  PasAI.FPC.GenericList,
{$ENDIF FPC}
  PasAI.PascalStrings, PasAI.UPascalStrings, PasAI.UnicodeMixedLib, PasAI.Status,
  PasAI.DrawEngine, PasAI.Geometry2D, PasAI.Geometry3D, PasAI.Parsing,
  PasAI.MemoryRaster, PasAI.MemoryStream;

type
  TBox_List_Tool<T_> = class(TCore_Object_Intermediate)
  public type
    PT_ = ^T_;

    TBox_Data = class(TCore_Object_Intermediate)
      Scene_Box: TRectV2;
      In_Screen: Boolean;
      Text_: U_String;
      Data: T_;
    end;

    TBox_Data_List__ = TBigList<TBox_Data>;
  private
    FVisibled_List: TBox_Data_List__;
    FDownScreenPT, FDownScenePT: TVec2;
    FMoveScreenPT, FMoveScenePT: TVec2;
    FMoveDistance: TGeoFloat;
    FUpScreenPT, FUpScenePT: TVec2;
    FDownState: Boolean;
    FMax_Box: TRectV2;
    FChanged: Boolean;

    procedure DoAdd__(var Box: TBox_Data);
    procedure DoFree__(var Box: TBox_Data);
    function Pick_Box_(D_: TDrawEngine; pt: TVec2): TBox_Data; // fast pick
  public
    // base
    List: TBox_Data_List__;
    xGridSpacing, yGridSpacing: TDEFloat;
    Box_Width, Box_Height: TDEFloat;
    Box_Line_Color: TDEColor;
    Box_Line_Width: TDEFloat;
    Box_Text_Size: TDEFloat;
    Box_Text_Color: TDEColor;
    Box_Text_Pos: TVec2;
    Box_Text_BK: Boolean; // draw text background
    Box_Text_BK_Color: TDEColor;

    // tap state
    property DownScreenPT: TVec2 read FDownScreenPT;
    property DownScenePT: TVec2 read FDownScenePT;
    property MoveScreenPT: TVec2 read FMoveScreenPT;
    property MoveScenePT: TVec2 read FMoveScenePT;
    property MoveDistance: TGeoFloat read FMoveDistance;
    property UpScreenPT: TVec2 read FUpScreenPT;
    property UpScenePT: TVec2 read FUpScenePT;
    property DownState: Boolean read FDownState;
    property Max_Box: TRectV2 read FMax_Box;

    // structor
    constructor Create;
    destructor Destroy; override;
    // operation, screen-point
    procedure Down(D_: TDrawEngine; pt: TVec2);
    procedure Move(D_: TDrawEngine; pt: TVec2);
    procedure Up(D_: TDrawEngine; pt: TVec2);
    procedure ScaleFromWheelDelta(D_: TDrawEngine; WheelDelta: Integer);
    procedure ScrollFromWheelDelta(D_: TDrawEngine; WheelDelta: Integer);
    function Get_Scroll(D_: TDrawEngine): TDEFloat;
    function ScrollTo(D_: TDrawEngine; Value_: TDEFloat): Boolean;
    function Pick(D_: TDrawEngine; pt: TVec2): PT_;
    // draw
    procedure Compute_Screen_Box_Size(D_: TDrawEngine); virtual;
    procedure Draw_Screen(D_: TDrawEngine);
    // intf
    procedure DoAdd(var Data: T_); virtual;
    procedure DoFree(var Data: T_); virtual;
    procedure DoDraw(D_: TDrawEngine; Screen_Box: TRectV2; Data: T_); virtual;
    procedure DoDown(var Data: T_); virtual;
    procedure DoMove(var Data: T_); virtual;
    procedure DoUp(var Data: T_); virtual;
    procedure DoClick(var Data: T_); virtual;
    procedure Add(Text_: U_String; Data_: T_); virtual;
  end;

implementation

procedure TBox_List_Tool<T_>.DoAdd__(var Box: TBox_Data);
begin
  FChanged := True;
  DoAdd(Box.Data);
end;

procedure TBox_List_Tool<T_>.DoFree__(var Box: TBox_Data);
begin
  FChanged := True;
  DoFree(Box.Data);
  DisposeObject(Box);
end;

function TBox_List_Tool<T_>.Pick_Box_(D_: TDrawEngine; pt: TVec2): TBox_Data;
var
  spt: TVec2; // screen pt
begin
  Result := nil;
  spt := D_.ScreenToScene(pt);
  if FVisibled_List.Num > 0 then
    with FVisibled_List.Repeat_ do
      repeat
        if Vec2InRect(spt, queue^.Data.Scene_Box) then
            exit(queue^.Data);
      until not next;
end;

constructor TBox_List_Tool<T_>.Create;
begin
  inherited Create;
  FVisibled_List := TBox_Data_List__.Create;
  FDownScreenPT := Vec2(0, 0);
  FDownScenePT := Vec2(0, 0);
  FMoveScreenPT := FDownScreenPT;
  FMoveScenePT := FDownScenePT;
  FMoveDistance := 0;
  FUpScreenPT := FMoveScreenPT;
  FUpScenePT := FUpScreenPT;
  FDownState := False;
  FMax_Box := NULLRect;
  FChanged := False;

  List := TBox_Data_List__.Create;
  List.OnAdd := DoAdd__;
  List.OnFree := DoFree__;
  xGridSpacing := 5;
  yGridSpacing := 5;
  Box_Width := 100;
  Box_Height := 100;

  Box_Line_Color := DEColor(1, 1, 1, 1);
  Box_Line_Width := 1;
  Box_Text_Size := 10;
  Box_Text_Color := DEColor(1, 1, 1, 1);
  Box_Text_Pos := Vec2(0.5, 1);
  Box_Text_BK := False;
  Box_Text_BK_Color := DEColor(0, 0, 0, 0.8);
end;

destructor TBox_List_Tool<T_>.Destroy;
begin
  DisposeObject(FVisibled_List);
  DisposeObject(List);
  inherited Destroy;
end;

procedure TBox_List_Tool<T_>.Down(D_: TDrawEngine; pt: TVec2);
var
  b: TBox_Data;
begin
  FDownScreenPT := pt;
  FDownScenePT := D_.ScreenToScene(pt);
  FMoveScreenPT := FDownScreenPT;
  FMoveScenePT := FDownScenePT;
  FUpScreenPT := FDownScreenPT;
  FUpScenePT := FDownScenePT;
  FDownState := True;

  b := Pick_Box_(D_, pt);
  if b <> nil then
      DoDown(b.Data);
end;

procedure TBox_List_Tool<T_>.Move(D_: TDrawEngine; pt: TVec2);
var
  b: TBox_Data;
begin
  FMoveScreenPT := pt;
  FMoveScenePT := D_.ScreenToScene(pt);
  FUpScreenPT := FDownScreenPT;
  FUpScenePT := FDownScenePT;

  b := Pick_Box_(D_, pt);
  if b <> nil then
      DoMove(b.Data);
end;

procedure TBox_List_Tool<T_>.Up(D_: TDrawEngine; pt: TVec2);
var
  b: TBox_Data;
  down_b: TBox_Data;
begin
  FUpScreenPT := pt;
  FUpScenePT := D_.ScreenToScene(pt);
  FDownState := False;

  b := Pick_Box_(D_, pt);
  if b <> nil then
      DoUp(b.Data);

  down_b := Pick_Box_(D_, FDownScreenPT);
  if (b <> nil) and (b = down_b) then
      DoClick(b.Data);
end;

procedure TBox_List_Tool<T_>.ScaleFromWheelDelta(D_: TDrawEngine; WheelDelta: Integer);
begin
  D_.Scale := D_.Scale + if_(WheelDelta > 0, 0.1, -0.1);
  FChanged := True;
end;

procedure TBox_List_Tool<T_>.ScrollFromWheelDelta(D_: TDrawEngine; WheelDelta: Integer);
var
  v: TVec2;
begin
  if RectInRect(FMax_Box, D_.CameraR) then
      exit;
  if WheelDelta > 0 then
      D_.Offset[1] := D_.Offset[1] + 100
  else
      D_.Offset[1] := D_.Offset[1] - 100;

  v := D_.Camera_LeftTop;
  if v[1] < 0 then
    begin
      v[1] := 0;
      D_.Camera_LeftTop := v;
    end;
  v := D_.Camera_RightBottom;
  if v[1] > FMax_Box[1, 1] then
    begin
      v[1] := FMax_Box[1, 1];
      D_.Camera_RightBottom := v;
    end;
  FChanged := True;
end;

function TBox_List_Tool<T_>.Get_Scroll(D_: TDrawEngine): TDEFloat;
var
  v: TVec2;
begin
  if RectInRect(FMax_Box, D_.CameraR) then
      Result := 0
  else
    begin
      v := D_.Camera_RightBottom;
      Result := v[1] / RectHeight(FMax_Box);
    end;
end;

function TBox_List_Tool<T_>.ScrollTo(D_: TDrawEngine; Value_: TDEFloat): Boolean;
var
  Y: TDEFloat;
  v: TVec2;
begin
  Result := False;
  if RectInRect(FMax_Box, D_.CameraR) then
      exit;

  v := D_.Camera_RightBottom;
  v[1] := Value_ * RectHeight(FMax_Box);
  if v[1] > FMax_Box[1, 1] then
      v[1] := FMax_Box[1, 1];

  if IsEqual_Y(D_.Camera_RightBottom, v) then
      exit;

  D_.Camera_RightBottom := v;

  v := D_.Camera_LeftTop;
  if v[1] < 0 then
    begin
      v[1] := 0;
      D_.Camera_LeftTop := v;
    end;
  Result := True;
  FChanged := True;
end;

function TBox_List_Tool<T_>.Pick(D_: TDrawEngine; pt: TVec2): PT_;
var
  b: TBox_Data;
begin
  b := Pick_Box_(D_, pt);
  if b <> nil then
      Result := @b.Data
  else
      Result := nil;
end;

procedure TBox_List_Tool<T_>.Draw_Screen(D_: TDrawEngine);
var
  r, tr: TRectV2;
begin
  Compute_Screen_Box_Size(D_);
  if FVisibled_List.Num > 0 then
    with FVisibled_List.Repeat_ do
      repeat
        r := D_.SceneToScreen(queue^.Data.Scene_Box);
        DoDraw(D_, r, queue^.Data.Data);
        D_.DrawBox(r, Box_Line_Color, Box_Line_Width);
        if queue^.Data.Text_ <> '' then
          begin
            tr := D_.Compute_Text_Scale_Position_Box(RectEdge(r, -Box_Line_Width), queue^.Data.Text_, Box_Text_Size, Box_Text_Pos);
            if RectInRect(tr, RectEdge(r, -Box_Line_Width)) then
              begin
                if Box_Text_BK then
                    D_.Draw_BK_Text(queue^.Data.Text_, Box_Text_Size, tr, Box_Text_Color, Box_Text_BK_Color, False)
                else
                    D_.DrawText(queue^.Data.Text_, Box_Text_Size, tr, Box_Text_Color, False);
              end;
          end;
      until not next;
end;

procedure TBox_List_Tool<T_>.DoAdd(var Data: T_);
begin
end;

procedure TBox_List_Tool<T_>.DoFree(var Data: T_);
begin
end;

procedure TBox_List_Tool<T_>.DoDraw(D_: TDrawEngine; Screen_Box: TRectV2; Data: T_);
begin
end;

procedure TBox_List_Tool<T_>.Compute_Screen_Box_Size(D_: TDrawEngine);
var
  x, Y: TDEFloat;
  scene_size: TVec2;
begin
  if not FChanged then
      exit;
  FVisibled_List.Clear;
  Y := yGridSpacing;
  x := xGridSpacing;
  FMax_Box[0] := Vec2(x, Y);
  scene_size := D_.Scene_Size_Vec;
  if List.Num > 0 then
    with List.Repeat_ do
      repeat
        if x + Box_Width > scene_size[0] then
          begin
            FMax_Box[1, 0] := x;
            x := xGridSpacing;
            Y := Y + Box_Height + yGridSpacing;
          end;
        queue^.Data.Scene_Box := RectV2(x, Y, x + Box_Width, Y + Box_Height);
        queue^.Data.In_Screen := Rect_1Overlap2_or_Intersect(D_.SceneToScreen(queue^.Data.Scene_Box), D_.ScreenRectV2);
        if queue^.Data.In_Screen then
            FVisibled_List.Add(queue^.Data);
        x := x + Box_Width + xGridSpacing;
      until not next;
  FMax_Box[1, 1] := Y + Box_Height + yGridSpacing;
  FChanged := False;
end;

procedure TBox_List_Tool<T_>.DoDown(var Data: T_);
begin

end;

procedure TBox_List_Tool<T_>.DoMove(var Data: T_);
begin

end;

procedure TBox_List_Tool<T_>.DoUp(var Data: T_);
begin

end;

procedure TBox_List_Tool<T_>.DoClick(var Data: T_);
begin
end;

procedure TBox_List_Tool<T_>.Add(Text_: U_String; Data_: T_);
begin
  with List.Add_Null^ do
    begin
      Data := TBox_Data.Create;
      Data.Scene_Box := NULLRect;
      Data.In_Screen := False;
      Data.Text_ := Text_;
      Data.Data := Data_;
    end;
  FChanged := True;
end;

end.
