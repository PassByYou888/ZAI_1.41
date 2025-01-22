unit _169_Large_List_Draw_Frm;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Memo.Types,
  FMX.Controls.Presentation, FMX.ScrollBox, FMX.Memo, FMX.StdCtrls, FMX.Layouts,

  PasAI.Core, PasAI.PascalStrings, PasAI.UPascalStrings, PasAI.Status, PasAI.Notify, PasAI.UnicodeMixedLib,
  PasAI.Geometry2D, PasAI.Geometry3D,
  PasAI.HashList.Templet,
  PasAI.MemoryRaster, PasAI.DrawEngine, PasAI.DrawEngine.SlowFMX,
  PasAI.DrawEngine.BoxListTool;

type
  TMy_Def = class
  end;

  TMy_Box_List = TBox_List_Tool<TMy_Def>;

  T_169_Large_List_Draw_Form = class(TForm)
    sysTimer: TTimer;
    ScrollBar_: TSmallScrollBar;
    procedure FormMouseWheel(Sender: TObject; Shift: TShiftState; WheelDelta: Integer; var Handled: Boolean);
    procedure FormPaint(Sender: TObject; Canvas: TCanvas; const ARect: TRectF);
    procedure sysTimerTimer(Sender: TObject);
  private
  public
    bk: TPasAI_Raster;
    dIntf: TDrawEngineInterface_FMX;
    L: TMy_Box_List;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

var
  _169_Large_List_Draw_Form: T_169_Large_List_Draw_Form;

implementation

{$R *.fmx}


uses StyleModuleUnit;

constructor T_169_Large_List_Draw_Form.Create(AOwner: TComponent);
var
  i: Integer;
begin
  inherited Create(AOwner);
  bk := NewPasAI_Raster;
  bk.SetSize(128, 128);
  FillBlackGrayBackgroundTexture(bk, 32);
  dIntf := TDrawEngineInterface_FMX.Create;
  L := TMy_Box_List.Create;
  L.Box_Line_Color[3] := 0.5;
  for i := 0 to 500000 - 1 do
      L.Add(PFormat('%d', [i]), TMy_Def.Create);
end;

destructor T_169_Large_List_Draw_Form.Destroy;
begin
  DisposeObject(bk);
  DisposeObject(dIntf);
  DisposeObject(L);
  inherited Destroy;
end;

procedure T_169_Large_List_Draw_Form.FormMouseWheel(Sender: TObject; Shift: TShiftState; WheelDelta: Integer; var Handled: Boolean);
var
  d: TDrawEngine;
begin
  d := DrawPool(Self);
  if ssCtrl in Shift then
      L.ScaleFromWheelDelta(d, WheelDelta)
  else
      L.ScrollFromWheelDelta(d, WheelDelta);
  ScrollBar_.Value := L.Get_Scroll(d) * 100;
end;

procedure T_169_Large_List_Draw_Form.FormPaint(Sender: TObject; Canvas: TCanvas; const ARect: TRectF);
var
  d: TDrawEngine;
begin
  d := dIntf.SetSurfaceAndGetDrawPool(Canvas, Sender);
  d.ViewOptions := [voEdge, voFPS];
  d.DrawTile(bk);
  L.Draw_Screen(d);
  d.Flush;
  L.ScrollTo(d, ScrollBar_.Value * 0.01);
end;

procedure T_169_Large_List_Draw_Form.sysTimerTimer(Sender: TObject);
begin
  CheckThread;
  DrawPool.Progress;
  Invalidate;
end;

end.
