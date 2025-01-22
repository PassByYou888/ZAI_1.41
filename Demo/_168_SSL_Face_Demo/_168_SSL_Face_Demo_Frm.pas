unit _168_SSL_Face_Demo_Frm;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Memo.Types,
  FMX.Controls.Presentation, FMX.ScrollBox, FMX.Memo, FMX.StdCtrls,

  PasAI.Core, PasAI.PascalStrings, PasAI.UPascalStrings, PasAI.Status, PasAI.Notify, PasAI.UnicodeMixedLib,
  PasAI.Geometry2D, PasAI.Geometry3D,
  PasAI.HashList.Templet,
  PasAI.MemoryRaster, PasAI.DrawEngine, PasAI.DrawEngine.SlowFMX,
  PasAI.DrawEngine.PictureViewer,
  PasAI.AI.Common, PasAI.AI, PasAI.AI.Tech2022, PasAI.Learn, PasAI.Learn.Type_LIB;

type
  TFace_Box_Info = record
    box: TRectV2;
    classifier_: U_String;
    k: TLFloat;
  end;

  TFace_Box_Info_List = TBigList<TFace_Box_Info>;

  TFace_PictureViewerData = class(TPictureViewerData)
  public
    face_List: TFace_Box_Info_List;
    constructor Create; override;
    destructor Destroy; override;
  end;

  T_168_SSL_Face_Demo_Form = class(TForm)
    sysTimer: TTimer;
    open_test_face_Button: TButton;
    OpenDialog_: TOpenDialog;
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Single);
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
    procedure FormMouseWheel(Sender: TObject; Shift: TShiftState; WheelDelta: Integer; var Handled: Boolean);
    procedure FormPaint(Sender: TObject; Canvas: TCanvas; const ARect: TRectF);
    procedure open_test_face_ButtonClick(Sender: TObject);
    procedure sysTimerTimer(Sender: TObject);
  private
    procedure DoStatus_Backcall(Text_: SystemString; const ID: Integer);
  public
    viewer: TPictureViewerInterface;
    face_imgmat: TPas_AI_ImageMatrix;
    SSL_DNN: TPas_AI_TECH_2022_DNN_Thread_Pool;
    SSL_Learn: TLearn;
    face_detector: TPas_AI;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Do_Load_SSL;
    procedure Run_Test(viewer_pic: TFace_PictureViewerData; face_box: TRectV2; chip_: TPasAI_Raster);
  end;

var
  _168_SSL_Face_Demo_Form: T_168_SSL_Face_Demo_Form;

implementation

{$R *.fmx}


constructor TFace_PictureViewerData.Create;
begin
  inherited;
  face_List := TFace_Box_Info_List.Create;
end;

destructor TFace_PictureViewerData.Destroy;
begin
  DisposeObject(face_List);
  inherited;
end;

procedure T_168_SSL_Face_Demo_Form.sysTimerTimer(Sender: TObject);
begin
  CheckThread;
  DrawPool.Progress;
  Invalidate;
end;

procedure T_168_SSL_Face_Demo_Form.DoStatus_Backcall(Text_: SystemString; const ID: Integer);
begin
  viewer.DrawEng.PostScrollText(15, TDrawEngine.RebuildNumColor(Text_, '|color(1,0.5,0.5)|', '||'), 12, DEColor(1, 1, 1), DEColor(0, 0, 0));
end;

constructor T_168_SSL_Face_Demo_Form.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  viewer := TPictureViewerInterface.Create(DrawPool(self));
  viewer.Picture_Class := TFace_PictureViewerData;
  viewer.ShowBackground := True;
  viewer.PictureViewerStyle := pvsDynamic;
  viewer.DrawEng.Scroll_Text_Direction := TScroll_Text_Direction.stdRB;

  StatusThreadID := False;
  AddDoStatusHook(self, DoStatus_Backcall);
  ReadAIConfig();
  Prepare_AI_Engine();
  Prepare_AI_Engine_TECH_2022();
  face_imgmat := TPas_AI_ImageMatrix.Create;
  TCompute.RunM_NP(Do_Load_SSL);
end;

destructor T_168_SSL_Face_Demo_Form.Destroy;
begin
  DisposeObject(SSL_Learn);
  DisposeObject(SSL_DNN);
  DisposeObject(face_detector);
  DisposeObject(face_imgmat);
  RemoveDoStatusHook(self);
  DisposeObject(viewer);
  inherited Destroy;
end;

procedure T_168_SSL_Face_Demo_Form.Do_Load_SSL;
var
  i: Integer;
  AI: TPas_AI_TECH_2022;
begin
  face_imgmat.LoadFromFile(WhereFileFromConfigure('face_ssl_align_test.imgMat'));
  SSL_DNN := TPas_AI_TECH_2022_DNN_Thread_Pool.Create;

  SSL_DNN.BuildPerDeviceThread(4, TPas_AI_TECH_2022_DNN_Thread_SSL);
  for i := 0 to SSL_DNN.Count - 1 do
      TPas_AI_TECH_2022_DNN_Thread_SSL(SSL_DNN[i]).Open_Face_Classifier;
  SSL_DNN.Wait;

  SSL_Learn := TPas_AI_TECH_2022.Build_SSL_Learn;
  AI := TPas_AI_TECH_2022.OpenEngine();
  DoStatus('processing...');
  AI.SSL_Save_To_Learn_DNN_Thread(10, SSL_DNN, nil, face_imgmat, SSL_Learn);
  SSL_DNN.Wait;
  SSL_Learn.Training;
  DoStatus('analysis...');
  with SSL_Learn.Build_Token_Analysis do
    begin
      if num > 0 then
        with Repeat_ do
          repeat
              DoStatus('%s:%d', [queue^.Data^.Data.Primary, queue^.Data^.Data.Second]);
          until not Next;
      Free;
    end;
  DoStatus('total face:%d learn:%d', [face_imgmat.ImageCount, SSL_Learn.Count]);

  DisposeObject(AI);
  face_detector := TPas_AI.OpenEngine;
  TCompute.Sync(procedure
    begin
      open_test_face_Button.Enabled := True;
    end);
end;

procedure T_168_SSL_Face_Demo_Form.FormMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
begin
  if Button = TMouseButton.mbLeft then
      viewer.TapDown(vec2(X, Y));
end;

procedure T_168_SSL_Face_Demo_Form.FormMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Single);
begin
  viewer.TapMove(vec2(X, Y));
end;

procedure T_168_SSL_Face_Demo_Form.FormMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
begin
  if Button = TMouseButton.mbLeft then
      viewer.TapUp(vec2(X, Y));
end;

procedure T_168_SSL_Face_Demo_Form.FormMouseWheel(Sender: TObject; Shift: TShiftState; WheelDelta: Integer; var Handled: Boolean);
begin
  viewer.ScaleCameraFromWheelDelta(WheelDelta);
  Handled := True;
end;

procedure T_168_SSL_Face_Demo_Form.FormPaint(Sender: TObject; Canvas: TCanvas; const ARect: TRectF);
var
  d: TDrawEngine;
  i: Integer;
  viewer_pic: TFace_PictureViewerData;
  r: TRectV2;
begin
  Canvas.Font.Family := 'Consolas';
  viewer.DrawEng := TDrawEngineInterface_FMX.DrawEngine_Interface.SetSurfaceAndGetDrawPool(Canvas, Sender);
  viewer.Render(True, False);
  d := viewer.DrawEng;

  for i := 0 to viewer.Count - 1 do
    begin
      viewer_pic := viewer[i] as TFace_PictureViewerData;
      if viewer_pic.face_List.num > 0 then
        with viewer_pic.face_List.Repeat_ do
          repeat
            r := RectProjection(viewer_pic.Raster.BoundsRectV2, viewer_pic.ScreenBox, queue^.Data.box);
            d.DrawLabelBox(PFormat('%s |color(1,0,0)|%f||', [queue^.Data.classifier_.Text, queue^.Data.k]), 16, DEColor(0, 0, 0), r, DEColor(0.5, 1, 0.5), 1);
          until not Next;
    end;

  viewer.Flush;
end;

procedure T_168_SSL_Face_Demo_Form.open_test_face_ButtonClick(Sender: TObject);
begin
  if not OpenDialog_.Execute then
      exit;

  TCompute.RunP_NP(procedure
    var
      pic: TMPasAI_Raster;
      hnd: TFACE_Handle;
      i, j: Integer;
      tmp: TPasAI_Raster;
      viewer_pic: TFace_PictureViewerData;
    begin
      for j := 0 to OpenDialog_.Files.Count - 1 do
        begin
          pic := NewPasAI_RasterFromFile(OpenDialog_.Files[j]);
          TCompute.Sync(procedure
            begin
              viewer_pic := viewer.InputPicture(pic, True, True) as TFace_PictureViewerData;
            end);

          hnd := face_detector.Face_Detector_All(pic, 100);

          for i := 0 to face_detector.Face_chips_num(hnd) - 1 do
            begin
              tmp := face_detector.Face_chips(hnd, i);
              Run_Test(viewer_pic, face_detector.Face_RectV2(hnd, i), tmp);
            end;

          face_detector.Face_Close(hnd);
        end;
    end);
end;

procedure T_168_SSL_Face_Demo_Form.Run_Test(viewer_pic: TFace_PictureViewerData; face_box: TRectV2; chip_: TPasAI_Raster);
begin
  TPas_AI_TECH_2022_DNN_Thread_SSL(SSL_DNN.MinLoad_DNN_Thread).Process_P(
  nil, chip_, False, 1, True,
    procedure(ThSender: TPas_AI_TECH_2022_DNN_Thread_SSL; UserData: Pointer; Input: TMPasAI_Raster; jitter_random: Boolean; Jitter_Num: Integer; output_sampling: TArrayV2R4; output: TLMatrix)
    var
      bi: TFace_Box_Info;
    begin
      bi.box := face_box;
      bi.classifier_ := TPas_AI_TECH_2022.Fast_Process_SSL_Token(SSL_Learn, output, bi.k);
      viewer_pic.face_List.Lock;
      viewer_pic.face_List.Add(bi);
      viewer_pic.face_List.UnLock;
    end);
end;

end.
