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
{ * Navigation polygon                                                         * }
{ ****************************************************************************** }
unit PasAI.Nav.Polygon;

{$DEFINE FPC_DELPHI_MODE}
{$I PasAI.Define.inc}

interface

uses PasAI.Core, Math, PasAI.Geometry2D;

type
  TPolyManager = class;

  TPolyManagerChildren = class(TDeflectionPolygon)
  protected
    FOwner: TPolyManager;
    FIndex: Integer;
  public
    constructor Create(Owner_: TPolyManager);
    destructor Destroy; override;

    property Owner: TPolyManager read FOwner;

    // cache in connect use
    property index: Integer read FIndex;
  end;

  TPolyManager = class(TCore_Persistent_Intermediate)
  protected
    FPolyList: TCore_ListForObj;
    FScene: TPolyManagerChildren;
  public
    constructor Create;
    destructor Destroy; override;

    procedure Clear;
    procedure Add(Poly: TPolyManagerChildren);
    function AddPointList(pl: TV2L): TPolyManagerChildren;
    procedure AddConvexHullPointList(pl: TV2L);
    function Count: Integer;
    procedure Delete(idx: Integer);
    procedure DeletePoly(p: TPolyManagerChildren);
    function GetPoly(index: Integer): TPolyManagerChildren;
    property Poly[index: Integer]: TPolyManagerChildren read GetPoly; default;
    function Last: TPolyManagerChildren;
    procedure AssignFrom(APoly: TPolyManager);

    function PointOk(ExpandDist_: TGeoFloat; pt: TVec2): Boolean;
    function LineIntersect(ExpandDist_: TGeoFloat; lb, le: TVec2): Boolean;
    function GetNearLine(ExtandDistance_: TGeoFloat; const pt: TVec2): TVec2;
    function Collision2Circle(cp: TVec2; r: TGeoFloat; OutputList: TDeflectionPolygonLines): Boolean;

    procedure Rebuild;
    procedure Reverse;
    procedure SetScale(v: TGeoFloat);
    procedure SetAngle(v: TGeoFloat);
    procedure ReverseY;
    procedure ReverseX;

    property Scene: TPolyManagerChildren read FScene;
  end;

implementation

constructor TPolyManagerChildren.Create(Owner_: TPolyManager);
begin
  inherited Create;
  FOwner := Owner_;
end;

destructor TPolyManagerChildren.Destroy;
begin
  inherited Destroy;
end;

constructor TPolyManager.Create;
begin
  inherited Create;
  FPolyList := TCore_ListForObj.Create;
  FScene := TPolyManagerChildren.Create(Self);
  FScene.ExpandMode := emConcave;
  FScene.FIndex := 0;
end;

destructor TPolyManager.Destroy;
begin
  Clear;
  DisposeObject(FPolyList);
  DisposeObject(FScene);
  inherited Destroy;
end;

procedure TPolyManager.Clear;
var
  i: Integer;
begin
  for i := 0 to FPolyList.Count - 1 do
      DisposeObject(TPolyManagerChildren(FPolyList[i]));
  FPolyList.Clear;
  FScene.Clear;
end;

procedure TPolyManager.Add(Poly: TPolyManagerChildren);
begin
  Poly.FIndex := FPolyList.Add(Poly) + 1;
end;

function TPolyManager.AddPointList(pl: TV2L): TPolyManagerChildren;
var
  APoly: TPolyManagerChildren;
begin
  APoly := TPolyManagerChildren.Create(Self);
  APoly.ExpandMode := emConvex;
  APoly.Rebuild(pl, True);
  Add(APoly);
  Result := APoly;
end;

procedure TPolyManager.AddConvexHullPointList(pl: TV2L);
var
  APoly: TPolyManagerChildren;
begin
  APoly := TPolyManagerChildren.Create(Self);
  APoly.ExpandMode := emConvex;
  APoly.ConvexHullFrom(pl);
  Add(APoly);
end;

function TPolyManager.Count: Integer;
begin
  Result := FPolyList.Count;
end;

procedure TPolyManager.Delete(idx: Integer);
var
  i: Integer;
begin
  DisposeObject(TPolyManagerChildren(FPolyList[idx]));
  FPolyList.Delete(idx);
  for i := 0 to Count - 1 do
      Poly[i].FIndex := i + 1;
end;

procedure TPolyManager.DeletePoly(p: TPolyManagerChildren);
var
  i: Integer;
begin
  i := 0;
  while i < Count do
    if Poly[i] = p then
        Delete(i)
    else
        inc(i);
end;

function TPolyManager.GetPoly(index: Integer): TPolyManagerChildren;
begin
  Result := FPolyList[index] as TPolyManagerChildren;
end;

function TPolyManager.Last: TPolyManagerChildren;
begin
  Result := Poly[Count - 1];
end;

procedure TPolyManager.AssignFrom(APoly: TPolyManager);
var
  i: Integer;
  np: TPolyManagerChildren;
begin
  Clear;
  for i := 0 to APoly.Count - 1 do
    begin
      np := TPolyManagerChildren.Create(Self);
      np.CopyPoly(APoly[i], False);
      Add(np);
    end;
  FScene.CopyPoly(APoly.Scene, False);
end;

function TPolyManager.PointOk(ExpandDist_: TGeoFloat; pt: TVec2): Boolean;
var
  i: Integer;
begin
  Result := False;
  if not FScene.InHere(ExpandDist_, pt) then
      Exit;
  for i := 0 to Count - 1 do
    if GetPoly(i).InHere(ExpandDist_, pt) then
        Exit;
  Result := True;
end;

function TPolyManager.LineIntersect(ExpandDist_: TGeoFloat; lb, le: TVec2): Boolean;
var
  i: Integer;
begin
  Result := False;
  for i := 0 to Count - 1 do
    begin
      if Poly[i].LineIntersect(ExpandDist_, lb, le, True) then
        begin
          Result := True;
          Exit;
        end;
    end;

  if FScene.LineIntersect(ExpandDist_, lb, le, True) then
      Result := True;
end;

function TPolyManager.GetNearLine(ExtandDistance_: TGeoFloat; const pt: TVec2): TVec2;
var
  i: Integer;
  d, d2: TGeoFloat;
  lb, le: Integer;
  r: TVec2;
begin
  Result := FScene.GetNearLine(ExtandDistance_, pt, True, lb, le);
  d := PointDistance(pt, Result);

  for i := 0 to Count - 1 do
    begin
      r := Poly[i].GetNearLine(ExtandDistance_, pt, True, lb, le);
      d2 := PointDistance(pt, r);
      if (d2 < d) then
        begin
          Result := r;
          d := d2;
        end;
    end;
end;

function TPolyManager.Collision2Circle(cp: TVec2; r: TGeoFloat; OutputList: TDeflectionPolygonLines): Boolean;
var
  i: Integer;
begin
  Result := False;
  for i := 0 to Count - 1 do
    begin
      if Poly[i].Collision2Circle(cp, r, True, OutputList) then
          Result := True;
    end;

  if FScene.Collision2Circle(cp, r, True, OutputList) then
      Result := True;
end;

procedure TPolyManager.Rebuild;
var
  i: Integer;
begin
  for i := 0 to Count - 1 do
      Poly[i].Rebuild;
  FScene.Rebuild;
end;

procedure TPolyManager.Reverse;
var
  i: Integer;
begin
  for i := 0 to Count - 1 do
      Poly[i].Reverse;
  FScene.Reverse;
end;

procedure TPolyManager.SetScale(v: TGeoFloat);
var
  i: Integer;
begin
  for i := 0 to Count - 1 do
      Poly[i].Scale := v;
  FScene.Scale := v;
end;

procedure TPolyManager.SetAngle(v: TGeoFloat);
var
  i: Integer;
begin
  for i := 0 to Count - 1 do
      Poly[i].angle := v;
  FScene.angle := v;
end;

procedure TPolyManager.ReverseY;
  procedure RY(p: TPolyManagerChildren);
  var
    i: Integer;
    pt: TVec2;
  begin
    for i := 0 to p.Count - 1 do
      begin
        pt := p.Points[i];
        pt[1] := -pt[1];
        p.Points[i] := pt;
      end;
  end;

var
  i: Integer;
begin
  for i := 0 to Count - 1 do
      RY(Poly[i]);
  RY(FScene);
end;

procedure TPolyManager.ReverseX;
  procedure RY(p: TPolyManagerChildren);
  var
    i: Integer;
    pt: TVec2;
  begin
    for i := 0 to p.Count - 1 do
      begin
        pt := p.Points[i];
        pt[0] := -pt[0];
        p.Points[i] := pt;
      end;
  end;

var
  i: Integer;
begin
  for i := 0 to Count - 1 do
      RY(Poly[i]);
  RY(FScene);
end;

end.
