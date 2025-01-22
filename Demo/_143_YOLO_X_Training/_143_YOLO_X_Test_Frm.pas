unit _143_YOLO_X_Test_Frm;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Controls.Presentation,
  FMX.StdCtrls, FMX.Objects, FMX.ScrollBox, FMX.Memo,
  FMX.Layouts, FMX.ExtCtrls, FMX.Memo.Types,

  FMX.DialogService, System.IOUtils,

  PasAI.Core,
  PasAI.Learn, PasAI.Learn.Type_LIB,
  PasAI.AI, PasAI.AI.Tech2022, PasAI.AI.Common,
  PasAI.DrawEngine.SlowFMX, PasAI.DrawEngine, PasAI.Geometry2D, PasAI.MemoryRaster, PasAI.Expression,
  PasAI.MemoryStream, PasAI.PascalStrings, PasAI.UnicodeMixedLib, PasAI.Status,
  PasAI.HashList.Templet, PasAI.ListEngine,
  PasAI.DrawEngine.PictureViewer, FMX.Edit;

type
  T_143_YOLO_X_Test_Form = class;

  TAI_Image_Viewer = class(TPictureViewerData)
  public
    Form: T_143_YOLO_X_Test_Form;
    AI_Image: TPas_AI_Image;
    YOLO_DESC: TAI_TECH_2022_DESC;
    constructor Create; override;
    destructor Destroy; override;
  end;

  T_143_YOLO_X_Test_Form = class(TForm)
    fpsTimer: TTimer;
    Clear_Box_Button: TButton;
    Test_Button: TButton;
    Layout1: TLayout;
    Label1: TLabel;
    image_resize_Edit: TEdit;
    Layout2: TLayout;
    Label2: TLabel;
    threshold_Edit: TEdit;
    procedure fpsTimerTimer(Sender: TObject);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Single);
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
    procedure FormMouseWheel(Sender: TObject; Shift: TShiftState; WheelDelta: Integer; var Handled: Boolean);
    procedure FormPaint(Sender: TObject; Canvas: TCanvas; const ARect: TRectF);
    procedure Clear_Box_ButtonClick(Sender: TObject);
    procedure Test_ButtonClick(Sender: TObject);
  private
    { Private declarations }
  public
    dIntf: TDrawEngineInterface_FMX;
    ViewIntf: TPictureViewerInterface;
    imgL: TPas_AI_ImageList;

    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Do_Clear_YOLO_DESC;
    procedure Do_Test();
  end;

var
  _143_YOLO_X_Test_Form: T_143_YOLO_X_Test_Form;

implementation

{$R *.fmx}


uses StyleModuleUnit, _143_YOLO_X_Training_Frm;

constructor TAI_Image_Viewer.Create;
begin
  inherited Create;
  Form := nil;
  AI_Image := nil;
  SetLength(YOLO_DESC, 0);
end;

destructor TAI_Image_Viewer.Destroy;
begin
  inherited Destroy;
end;

procedure T_143_YOLO_X_Test_Form.fpsTimerTimer(Sender: TObject);
begin
  if not Visible then
      exit;
  Check_Soft_Thread_Synchronize;
  DrawPool.Progress;
  Invalidate;
end;

procedure T_143_YOLO_X_Test_Form.FormMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
begin
  ViewIntf.TapDown(Vec2(X, Y));
end;

procedure T_143_YOLO_X_Test_Form.FormMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Single);
begin
  ViewIntf.TapMove(Vec2(X, Y));
end;

procedure T_143_YOLO_X_Test_Form.FormMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
begin
  ViewIntf.TapUp(Vec2(X, Y));
end;

procedure T_143_YOLO_X_Test_Form.FormMouseWheel(Sender: TObject; Shift: TShiftState; WheelDelta: Integer; var Handled: Boolean);
begin
  ViewIntf.ScaleCameraFromWheelDelta(WheelDelta);
  Handled := True;
end;

procedure T_143_YOLO_X_Test_Form.FormPaint(Sender: TObject; Canvas: TCanvas; const ARect: TRectF);
var
  d: TDrawEngine;
  i, j: Integer;
  img_view: TAI_Image_Viewer;
  R2: TRectV2;
begin
  Canvas.Font.Style := [TFontStyle.fsBold];
  ViewIntf.DrawEng := dIntf.SetSurfaceAndGetDrawPool(Canvas, Sender);
  d := ViewIntf.DrawEng;

  ViewIntf.Render(True, False);

  // À—À˜≈‰∂‘box
  for i := 0 to ViewIntf.Count - 1 do
    begin
      img_view := ViewIntf[i] as TAI_Image_Viewer;
      for j := 0 to length(img_view.YOLO_DESC) - 1 do
        begin
          R2 := RectProjection(img_view.AI_Image.Raster.BoundsRectV20, img_view.ScreenBox, img_view.YOLO_DESC[j].R);
          if Rect_Overlap_or_Intersect(R2, d.ScreenRectV2) then
            begin
              d.DrawLabelBox(PFormat('"%s", %f', [img_view.YOLO_DESC[j].Token.Text, img_view.YOLO_DESC[j].confidence]), 12, DEColor(1, 1, 1), R2, DEColor(1, 0, 0), 2);
            end;
        end;
    end;

  ViewIntf.Flush;
end;

procedure T_143_YOLO_X_Test_Form.Clear_Box_ButtonClick(Sender: TObject);
begin
  Do_Clear_YOLO_DESC;
end;

procedure T_143_YOLO_X_Test_Form.Test_ButtonClick(Sender: TObject);
begin
  TCompute.RunM_NP(Do_Test);
end;

constructor T_143_YOLO_X_Test_Form.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  dIntf := TDrawEngineInterface_FMX.Create;
  ViewIntf := TPictureViewerInterface.Create(DrawPool(self));
  ViewIntf.Viewer_Class := TAI_Image_Viewer;
  ViewIntf.PictureViewerStyle := pvsDynamic;
  ViewIntf.AutoFit := False;

  _143_YOLO_X_Training_Form.Test_Button.Enabled := False;

  imgL := TPas_AI_ImageList.Create;

  TCompute.RunP_NP(procedure
    begin
      // ∂¡»°—˘±æø‚
      imgL.LoadFromFile(WhereFileFromConfigure('5dance.ImgDataSet'));

      TCompute.Sync(procedure
        var
          i: Integer;
          img_view: TAI_Image_Viewer;
        begin
          //  ‰»ÎµΩÕº∆¨‘§¿¿∆˜
          for i := 0 to imgL.Count - 1 do
            begin
              img_view := ViewIntf.InputPicture(imgL[i].Raster, imgL[i].FileInfo, True, False) as TAI_Image_Viewer;
              img_view.Form := self;
              img_view.AI_Image := imgL[i];
            end;
          _143_YOLO_X_Training_Form.Test_Button.Enabled := True;
        end);
    end);

  DrawPool(self).PostScrollText(1, 'YOLO-X≤‚ ‘≥Ã–Ú.', 20, DEColor(0.65, 1.0, 0.65), DEColor(0, 0, 0, 0.9)).Forever := True;
end;

destructor T_143_YOLO_X_Test_Form.Destroy;
begin
  disposeObject(ViewIntf);
  disposeObject(imgL);
  inherited Destroy;
end;

procedure T_143_YOLO_X_Test_Form.Do_Clear_YOLO_DESC;
var
  i: Integer;
  img_view: TAI_Image_Viewer;
  YOLO_DESC: TAI_TECH_2022_DESC;
begin
  for i := 0 to ViewIntf.Count - 1 do
    begin
      img_view := ViewIntf[i] as TAI_Image_Viewer;
      SetLength(img_view.YOLO_DESC, 0);
    end;
end;

procedure T_143_YOLO_X_Test_Form.Do_Test;
var
  AI_2022: TPas_AI_TECH_2022;
  hnd: TPas_AI_TECH_2022_YOLO_X_Handle;
  fn: U_String;
  i: Integer;
  img_view: TAI_Image_Viewer;
  YOLO_DESC: TAI_TECH_2022_DESC;
begin
  TCompute.SyncM(Do_Clear_YOLO_DESC);
  fn := umlCombineFileName(AI_Work_Path, '_143_YOLO_X_Training' + C_YOLO_X_Ext);
  if not umlFileExists(fn) then
      exit;

  AI_2022 := TPas_AI_TECH_2022.OpenEngine;
  hnd := AI_2022.YOLO_X_Open(fn);

  for i := 0 to ViewIntf.Count - 1 do
    begin
      img_view := ViewIntf[i] as TAI_Image_Viewer;
      YOLO_DESC := AI_2022.YOLO_X_Process(hnd, img_view.AI_Image.Raster, EStrToFloat(threshold_Edit.Text));
      TCompute.Sync(procedure
        begin
          img_view.YOLO_DESC := YOLO_DESC;
          DrawPool(self).PostScrollText(5, PFormat('ÕÍ≥…≤‚ ‘ %s', [img_view.AI_Image.FileInfo.Text]), 14, DEColor(0.65, 1.0, 0.65), DEColor(0, 0, 0, 0.9));
        end);
    end;

  AI_2022.YOLO_X_Close(hnd);
  disposeObject(AI_2022);
end;

end.
