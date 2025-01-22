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
{ * Navigation path finding                                                    * }
{ ****************************************************************************** }
unit PasAI.Nav.PathFinding;

{$DEFINE FPC_DELPHI_MODE}
{$I PasAI.Define.inc}

interface

uses PasAI.Core, PasAI.Nav.Pass, PasAI.Geometry2D;

type
  TStepStackData = record
    PassIndex: Integer;
  end;

  PStepStackData = ^TStepStackData;
  TDecisionInt = -1 .. 1;

  TNavStepFinding = class(TCore_Persistent_Intermediate)
  private
    FPassManager: TPolyPassManager;
    FStackList: TCore_List;
    FSourcePositionPass, FTargetPositionPass: TPointPass;
    FSourcePositionPassIndex, FTargetPositionPassIndex: Integer;
    FSourcePosition, FTargetPosition: TVec2;
    FCurrentPassIndex: Integer;
    FPassStateID: ShortInt;
    FStepCount: Int64;
    FDone: Boolean;
    FAbort: Boolean;
    FIgnoreDynamicPoly: TCore_ListForObj;

    procedure InitState;
    procedure FreeState;
    procedure ResetState;

    procedure PushState;
    procedure PopState;
    function IsEmptyStack: Boolean;
  private
    {
      return state
      -1, prev step
      0: next step
      1: done to end position
    }
    function Decision(const StateID_: ShortInt; const B, E: Integer; out PassIndex: Integer): TDecisionInt;
  public
    constructor Create(PassManager_: TPolyPassManager);
    destructor Destroy; override;

    function FindPath(Sour_: TNavBio; Dest_: TVec2): Boolean;

    procedure ResetStep;
    procedure NextStep;
    function FindingPathOver: Boolean;

    procedure MakeCurrentPath(OutPath: TV2L);
    // Remove more/spam corner nodes
    procedure MakeLevel1OptimizationPath(OutPath: TV2L);
    // remmove intersect corner nodes
    procedure MakeLevel2OptimizationPath(OutPath: TV2L);
    // remove near lerp corner nodes
    procedure MakeLevel3OptimizationPath(OutPath: TV2L);
    // subdivision and lerp
    procedure MakeLevel4OptimizationPath(OutPath: TV2L);

    function GetSearchDepth: Integer;
    function GetStepCount: Integer;

    property PassManager: TPolyPassManager read FPassManager;
    property Done: Boolean read FDone;
    property Abort: Boolean read FAbort;
    function Success: Boolean;
  end;

procedure Level1OptimizationPath(CM: TPolyPassManager; ignore: TCore_ListForObj; Path_: TV2L; Radius_: TGeoFloat);
procedure Level2OptimizationPath(CM: TPolyPassManager; ignore: TCore_ListForObj; Path_: TV2L; Radius_: TGeoFloat; LowLap: Boolean);
procedure Level3OptimizationPath(CM: TPolyPassManager; ignore: TCore_ListForObj; Path_: TV2L; Radius_: TGeoFloat; LowLap: Boolean);
procedure Level4OptimizationPath(CM: TPolyPassManager; ignore: TCore_ListForObj; Path_: TV2L; Radius_: TGeoFloat; LowLap: Boolean);

implementation

procedure Level1OptimizationPath(CM: TPolyPassManager; ignore: TCore_ListForObj; Path_: TV2L; Radius_: TGeoFloat);
var
  i, j: Integer;
  pl: TV2L;
begin
  pl := TV2L.Create;
  pl.Assign(Path_);
  Path_.Clear;

  if pl.Count > 3 then
    begin
      i := 0;
      while i < pl.Count do
        begin
          Path_.Add(pl[i]^);
          j := pl.Count - 1;
          while j > i do
            begin
              if not CM.LineIntersect(Radius_, pl[i]^, pl[j]^, ignore) then
                begin
                  Path_.Add(pl[j]^);
                  i := j;
                  Break;
                end
              else
                  dec(j);
            end;
          inc(i);
        end;
    end
  else
      Path_.Assign(pl);
  DisposeObject(pl);
end;

procedure Level2OptimizationPath(CM: TPolyPassManager; ignore: TCore_ListForObj; Path_: TV2L; Radius_: TGeoFloat; LowLap: Boolean);
var
  pl: TV2L;
  B, E, ipt: TVec2;
  idx1, idx2: Integer;
begin
  pl := TV2L.Create;
  pl.Assign(Path_);
  Path_.Clear;
  if LowLap then
      Level1OptimizationPath(CM, ignore, pl, Radius_);

  if pl.Count >= 3 then
    begin
      B := pl[0]^;
      pl.Delete(0);
      Path_.Add(B);
      while pl.Count > 0 do
        begin
          E := pl[0]^;
          pl.Delete(0);

          if (pl.Line2NearIntersect(B, E, False, idx1, idx2, ipt)) then
            begin
              Path_.Add(ipt);
              E := pl[idx2]^;
              Path_.Add(E);
              B := E;
              while idx2 > 0 do
                begin
                  pl.Delete(0);
                  dec(idx2);
                end;
            end
          else
            begin
              Path_.Add(E);
              B := E;
            end;
        end;
      Level1OptimizationPath(CM, ignore, Path_, Radius_);
    end
  else
      Path_.Assign(pl);
  DisposeObject(pl);
end;

procedure Level3OptimizationPath(CM: TPolyPassManager; ignore: TCore_ListForObj; Path_: TV2L; Radius_: TGeoFloat; LowLap: Boolean);
  function LerpLineCheck(sour, E, B: TVec2; out OutPt: TVec2): Boolean;
  var
    i: Integer;
    ne: TVec2;
    SmoothLevel: Integer;
  begin
    Result := False;
    SmoothLevel := Trunc(PointDistance(B, E) / (Radius_ * 2));
    for i := 1 to SmoothLevel - 1 do
      begin
        ne := PointLerp(B, E, i * (1.0 / SmoothLevel));
        if not CM.LineIntersect(Radius_, sour, ne, ignore) then
          begin
            OutPt := ne;
            Result := True;
            Exit;
          end;
      end;
  end;

  function LerpCheck(sour: TVec2; pl: TV2L; out OutPt: TVec2; out NextIdx: Integer): Boolean;
  var
    i: Integer;
    B, E: TVec2;
  begin
    Result := False;
    if (pl.Count > 1) then
      begin
        B := pl[0]^;
        for i := 1 to pl.Count - 1 do
          begin
            E := pl[i]^;
            if (PointDistance(B, E) > (Radius_ * 2)) and (LerpLineCheck(sour, B, E, OutPt)) then
              begin
                NextIdx := i;
                Result := True;
                Exit;
              end;
            B := E;
          end;
      end;
  end;

var
  pl: TV2L;
  B, ipt: TVec2;
  idx: Integer;
begin
  pl := TV2L.Create;
  pl.Assign(Path_);
  Path_.Clear;
  if LowLap then
      Level2OptimizationPath(CM, ignore, pl, Radius_, True);

  if pl.Count >= 3 then
    begin
      while pl.Count > 0 do
        begin
          B := pl[0]^;
          Path_.Add(B);
          pl.Delete(0);

          if LerpCheck(B, pl, ipt, idx) then
            begin
              Path_.Add(ipt);
              Path_.Add(pl[idx]^);
              while idx > 0 do
                begin
                  pl.Delete(0);
                  dec(idx);
                end;
            end;
        end;

      pl.Assign(Path_);
      Path_.Clear;
      while pl.Count > 0 do
        begin
          B := pl[0]^;
          Path_.Add(B);
          pl.Delete(0);

          if LerpCheck(B, pl, ipt, idx) then
            begin
              Path_.Add(ipt);
              Path_.Add(pl[idx]^);
              while idx > 0 do
                begin
                  pl.Delete(0);
                  dec(idx);
                end;
            end;
        end;

      Level1OptimizationPath(CM, ignore, Path_, Radius_);
    end
  else
      Path_.Assign(pl);
  DisposeObject(pl);
end;

procedure Level4OptimizationPath(CM: TPolyPassManager; ignore: TCore_ListForObj; Path_: TV2L; Radius_: TGeoFloat; LowLap: Boolean);
var
  pl, pl2: TV2L;
  i: Integer;
begin
  pl := TV2L.Create;
  pl.Assign(Path_);
  if LowLap then
    begin
      Level3OptimizationPath(CM, ignore, pl, Radius_, True);
      pl.Reverse;
      Level3OptimizationPath(CM, ignore, pl, Radius_, False);
      pl.Reverse;
    end;
  Path_.Clear;

  if pl.Count > 0 then
    begin
      pl2 := TV2L.Create;
      for i := 0 to pl.Count - 1 do
          pl2.AddSubdivision(10, pl[i]^);
      Level3OptimizationPath(CM, ignore, pl2, Radius_, False);
      pl2.Reverse;
      Level3OptimizationPath(CM, ignore, pl2, Radius_, False);
      pl2.Reverse;

      pl.Clear;
      for i := 0 to pl2.Count - 1 do
          pl.AddSubdivision(10, pl2[i]^);
      Level3OptimizationPath(CM, ignore, pl, Radius_, False);
      pl.Reverse;
      Level3OptimizationPath(CM, ignore, pl, Radius_, False);
      pl.Reverse;

      Path_.Assign(pl);
      DisposeObject(pl2);
    end;
  DisposeObject(pl);
end;

procedure TNavStepFinding.InitState;
begin
  FStackList := TCore_List.Create;
  FSourcePositionPass := nil;
  FTargetPositionPass := nil;
  FSourcePositionPassIndex := -1;
  FTargetPositionPassIndex := -1;
  FSourcePosition := NULLPoint;
  FTargetPosition := NULLPoint;
  FCurrentPassIndex := -1;
  FPassStateID := 0;
  FStepCount := 0;
  FDone := False;
  FAbort := False;
  FIgnoreDynamicPoly := TCore_ListForObj.Create;
end;

procedure TNavStepFinding.FreeState;
begin
  ResetState;
  DisposeObject(FStackList);
  DisposeObject(FIgnoreDynamicPoly);
end;

procedure TNavStepFinding.ResetState;
var
  i: Integer;
begin
  for i := 0 to FStackList.Count - 1 do
      Dispose(PStepStackData(FStackList[i]));
  FStackList.Clear;

  if FSourcePositionPass <> nil then
    begin
      FSourcePositionPass.Delete;
    end;
  FSourcePositionPass := nil;

  if FTargetPositionPass <> nil then
    begin
      FTargetPositionPass.Delete;
    end;
  FTargetPositionPass := nil;

  FSourcePositionPassIndex := -1;
  FTargetPositionPassIndex := -1;
  FSourcePosition := NULLPoint;
  FTargetPosition := NULLPoint;

  FCurrentPassIndex := -1;
  FPassStateID := 0;
  FStepCount := 0;
  FDone := False;
  FAbort := False;

  FIgnoreDynamicPoly.Clear;
end;

procedure TNavStepFinding.PushState;
var
  p: PStepStackData;
begin
  new(p);
  p^.PassIndex := FCurrentPassIndex;
  FStackList.Add(p);
end;

procedure TNavStepFinding.PopState;
var
  p: PStepStackData;
begin
  if FStackList.Count > 0 then
    begin
      p := FStackList[FStackList.Count - 1];
      FCurrentPassIndex := p^.PassIndex;
      FStackList.Delete(FStackList.Count - 1);
      Dispose(p);
    end;
end;

function TNavStepFinding.IsEmptyStack: Boolean;
begin
  Result := FStackList.Count = 0;
end;

{
  return state
  -1, prev step
  0: next step
  1: done to end position
}

function TNavStepFinding.Decision(const StateID_: ShortInt; const B, E: Integer; out PassIndex: Integer): TDecisionInt;
var
  BC, EC: TBasePass;
  BP, EP: TVec2;
  BI: Integer;
  d, BD: TGeoFloat;
  i: Integer;
begin
  if (B < 0) or (E < 0) then
    begin
      // return prev step
      Result := -1;
      Exit;
    end;

  BC := FPassManager[B];
  EC := FPassManager[E];

  if BC.Exists(EC) and (BC[BC.IndexOf(EC)]^.Enabled(FIgnoreDynamicPoly)) then
    begin
      // return success
      PassIndex := EC.PassIndex;
      Result := 1;
      Exit;
    end;

  BP := BC.GetPosition;
  EP := EC.GetPosition;

  BI := -1;

  BD := 0;

  // compute distance
  for i := 0 to BC.Count - 1 do
    with BC.Data[i]^ do
      if (State <> StateID_) and (passed <> BC) and (Enabled(FIgnoreDynamicPoly)) then
        begin
          d := PointDistance(EP, passed.GetPosition);
          if (BD = 0) or (d < BD) then
            begin
              BI := i;
              BD := d;
            end;
        end;

  if (BI = -1) then
    begin
      // return prev step
      Result := -1;
      Exit;
    end;

  BC.State[BI] := StateID_;
  PassIndex := BC.Data[BI]^.passed.PassIndex;
  if PassIndex < 0 then
    begin
      // step prev step
      Result := -1;
      Exit;
    end;

  // next step
  Result := 0;
end;

constructor TNavStepFinding.Create(PassManager_: TPolyPassManager);
begin
  inherited Create;
  FPassManager := PassManager_;
  InitState;
end;

destructor TNavStepFinding.Destroy;
begin
  FreeState;
  inherited Destroy;
end;

function TNavStepFinding.FindPath(Sour_: TNavBio; Dest_: TVec2): Boolean;
var
  i: Integer;
begin
  ResetState;
  if Sour_.IsFlight then
    begin
      FSourcePosition := Sour_.DirectPosition;
      FTargetPosition := Dest_;
      FSourcePositionPass := TPointPass.Create(FPassManager, Sour_.DirectPosition);
      FTargetPositionPass := TPointPass.Create(FPassManager, Dest_);
      FSourcePositionPassIndex := FPassManager.Add(FSourcePositionPass, False);
      FTargetPositionPassIndex := FPassManager.Add(FTargetPositionPass, False);
      Result := True;
      Exit;
    end;

  FIgnoreDynamicPoly.Add(Sour_);
  Result := False;
  FSourcePosition := Sour_.DirectPosition;
  FTargetPosition := Dest_;
  FDone := not FPassManager.LineIntersect(FPassManager.ExtandDistance, Sour_.DirectPosition, Dest_, FIgnoreDynamicPoly);

  if not FPassManager.PointOk(FPassManager.ExtandDistance - 1, Sour_.DirectPosition, FIgnoreDynamicPoly) then
      Exit;
  if not FPassManager.PointOk(FPassManager.ExtandDistance - 1, Dest_, FIgnoreDynamicPoly) then
      Exit;

  if FDone then
    begin
      FSourcePositionPass := TPointPass.Create(FPassManager, Sour_.DirectPosition);
      FTargetPositionPass := TPointPass.Create(FPassManager, Dest_);
      FSourcePositionPassIndex := FPassManager.Add(FSourcePositionPass, False);
      FTargetPositionPassIndex := FPassManager.Add(FTargetPositionPass, False);
      Result := True;
    end
  else
    begin
      FSourcePositionPass := TPointPass.Create(FPassManager, Sour_.DirectPosition);
      FTargetPositionPass := TPointPass.Create(FPassManager, Dest_);
      FSourcePositionPassIndex := FPassManager.Add(FSourcePositionPass, True);
      FTargetPositionPassIndex := FPassManager.Add(FTargetPositionPass, True);
      for i := 0 to FPassManager.Count - 1 do
          FPassManager[i].PassIndex := i;

      FPassStateID := FPassManager.NewPassStateIncremental;

      case Decision(FPassStateID, FSourcePositionPassIndex, FTargetPositionPassIndex, FCurrentPassIndex) of
        - 1:
          begin
            // prev step
          end;
        0:
          begin
            // next step
            PushState;
            Result := True;
          end;
        else
          begin
            // done to dest
            FDone := True;
            Result := True;
          end;
      end;
    end;
end;

procedure TNavStepFinding.ResetStep;
var
  i: Integer;
begin
  if FTargetPositionPassIndex < 0 then
      Exit;
  if FSourcePositionPassIndex < 0 then
      Exit;
  if FSourcePositionPass = nil then
      Exit;
  if FTargetPositionPass = nil then
      Exit;

  FDone := False;
  FCurrentPassIndex := -1;
  FStepCount := 0;
  FDone := False;
  FAbort := False;

  for i := 0 to FStackList.Count - 1 do
      Dispose(PStepStackData(FStackList[i]));
  FStackList.Clear;

  FPassStateID := FPassManager.NewPassStateIncremental;

  case Decision(FPassStateID, FSourcePositionPassIndex, FTargetPositionPassIndex, FCurrentPassIndex) of
    - 1:
      begin
        // prev step
      end;
    0:
      begin
        // next step
        PushState;
      end;
    else
      begin
        // done to dest
        FDone := True;
      end;
  end;
end;

procedure TNavStepFinding.NextStep;
var
  r, i: Integer;
begin
  if FDone then
      Exit;
  if FAbort then
      Exit;
  if FCurrentPassIndex < 0 then
      Exit;
  if FTargetPositionPassIndex < 0 then
      Exit;
  if FSourcePositionPassIndex < 0 then
      Exit;
  if FSourcePositionPass = nil then
      Exit;
  if FTargetPositionPass = nil then
      Exit;

  inc(FStepCount);
  PushState;

  i := FCurrentPassIndex;
  r := Decision(FPassStateID, i, FTargetPositionPassIndex, FCurrentPassIndex);
  case r of
    - 1:
      begin
        // prev step
        PopState;
        if IsEmptyStack then
          begin
            FAbort := True;
            Exit;
          end;
        PopState;
      end;
    0:
      begin
        // next step
      end;
    else
      begin
        // done to dest
        FDone := True;
      end;
  end;
end;

function TNavStepFinding.FindingPathOver: Boolean;
begin
  Result := FDone or FAbort;
end;

procedure TNavStepFinding.MakeCurrentPath(OutPath: TV2L);
var
  i: Integer;
begin
  if FSourcePositionPass = nil then
      Exit;
  if FTargetPositionPass = nil then
      Exit;
  OutPath.Add(FSourcePositionPass.GetPosition);
  for i := 0 to FStackList.Count - 1 do
      OutPath.Add(FPassManager[PStepStackData(FStackList[i])^.PassIndex].GetPosition);
  if FindingPathOver and (not FAbort) then
      OutPath.Add(FTargetPositionPass.GetPosition);
end;

procedure TNavStepFinding.MakeLevel1OptimizationPath(OutPath: TV2L);
var
  pl: TV2L;
begin
  if FSourcePositionPass = nil then
      Exit;
  if FTargetPositionPass = nil then
      Exit;
  pl := TV2L.Create;
  MakeCurrentPath(pl);
  OutPath.Assign(pl);
  Level1OptimizationPath(FPassManager, FIgnoreDynamicPoly, OutPath, FPassManager.ExtandDistance);
  DisposeObject(pl);
end;

procedure TNavStepFinding.MakeLevel2OptimizationPath(OutPath: TV2L);
var
  pl: TV2L;
begin
  if FSourcePositionPass = nil then
      Exit;
  if FTargetPositionPass = nil then
      Exit;
  pl := TV2L.Create;
  MakeCurrentPath(pl);
  OutPath.Assign(pl);
  Level2OptimizationPath(FPassManager, FIgnoreDynamicPoly, OutPath, FPassManager.ExtandDistance, True);
  DisposeObject(pl);
end;

procedure TNavStepFinding.MakeLevel3OptimizationPath(OutPath: TV2L);
begin
  if FSourcePositionPass = nil then
      Exit;
  if FTargetPositionPass = nil then
      Exit;
  MakeCurrentPath(OutPath);
  Level3OptimizationPath(FPassManager, FIgnoreDynamicPoly, OutPath, FPassManager.ExtandDistance, True);
  OutPath.Reverse;
  Level3OptimizationPath(FPassManager, FIgnoreDynamicPoly, OutPath, FPassManager.ExtandDistance, True);
  OutPath.Reverse;
end;

procedure TNavStepFinding.MakeLevel4OptimizationPath(OutPath: TV2L);
begin
  if FSourcePositionPass = nil then
      Exit;
  if FTargetPositionPass = nil then
      Exit;
  MakeCurrentPath(OutPath);
  Level4OptimizationPath(FPassManager, FIgnoreDynamicPoly, OutPath, FPassManager.ExtandDistance, True);
end;

function TNavStepFinding.GetSearchDepth: Integer;
begin
  Result := FStackList.Count;
end;

function TNavStepFinding.GetStepCount: Integer;
begin
  Result := FStepCount;
end;

function TNavStepFinding.Success: Boolean;
begin
  Result := (not Abort) and (FDone)
end;

end.
