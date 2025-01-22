unit _143_YOLO_X_Training_Frm;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Controls.Presentation,
  FMX.StdCtrls, FMX.Objects, FMX.ScrollBox, FMX.Memo,
  FMX.Layouts, FMX.ExtCtrls, FMX.Memo.Types,

  FMX.DialogService, System.IOUtils,

  PasAI.Core,
  PasAI.DrawEngine.SlowFMX, PasAI.DrawEngine, PasAI.Geometry2D, PasAI.MemoryRaster,
  PasAI.MemoryStream, PasAI.PascalStrings, PasAI.UnicodeMixedLib, PasAI.Status, PasAI.Parsing,
  PasAI.HashList.Templet, PasAI.ListEngine,
  PasAI.AI, PasAI.AI.Tech2022, PasAI.AI.Common;

type
  T_143_YOLO_X_Training_Form = class(TForm)
    Memo: TMemo;
    training_Button: TButton;
    fpsTimer: TTimer;
    Now_Finished_Button: TButton;
    Test_Button: TButton;
    procedure fpsTimerTimer(Sender: TObject);
    procedure training_ButtonClick(Sender: TObject);
    procedure Now_Finished_ButtonClick(Sender: TObject);
    procedure Test_ButtonClick(Sender: TObject);
  private
    procedure backcall_DoStatus(Text_: SystemString; const ID: Integer);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Do_Train;
    procedure Do_Remove_Train_Model;
  end;

var
  _143_YOLO_X_Training_Form: T_143_YOLO_X_Training_Form;

implementation

{$R *.fmx}


uses StyleModuleUnit, _143_YOLO_X_Test_Frm;

procedure T_143_YOLO_X_Training_Form.fpsTimerTimer(Sender: TObject);
begin
  CheckThread;
end;

procedure T_143_YOLO_X_Training_Form.training_ButtonClick(Sender: TObject);
begin
  TCompute.RunM_NP(Do_Train);
end;

procedure T_143_YOLO_X_Training_Form.Now_Finished_ButtonClick(Sender: TObject);
begin
  TPas_AI_TECH_2022(Now_Finished_Button.TagObject).Training_Stop;
end;

procedure T_143_YOLO_X_Training_Form.backcall_DoStatus(Text_: SystemString; const ID: Integer);
begin
  Memo.Lines.Add(Text_);
  Memo.GoToTextEnd;
end;

constructor T_143_YOLO_X_Training_Form.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  StatusThreadID := False;
  AddDoStatusHook(self, backcall_DoStatus);
  CheckAndReadAIConfig();
  Prepare_AI_Engine();
  Prepare_AI_Engine_TECH_2022();
end;

destructor T_143_YOLO_X_Training_Form.Destroy;
begin
  RemoveDoStatusHook(self);
  inherited Destroy;
end;

procedure T_143_YOLO_X_Training_Form.Do_Train;
var
  fn: U_String;
  imgL, test_ImgL: TPas_AI_ImageList;
  p: PPas_AI_TECH_2022_YOLO_X_Train_Parameter;
  AI_2022: TPas_AI_TECH_2022;
begin
  DoStatus('启动YOLO-X训练,请不要关闭');
  TCompute.RunP_NP(procedure
    begin
      training_Button.Enabled := False;
      Now_Finished_Button.Enabled := True;
      Invalidate;
    end);

  imgL := TPas_AI_ImageList.Create;
  fn := WhereFileFromConfigure('5dance.ImgDataSet');
  DoStatus('load %s', [fn.Text]);
  imgL.LoadFromFile(fn);
  imgL.RunScript(TTextStyle.tsC, 'True', 'SetLabel("TEST")');
  DoStatus('done %s', [fn.Text]);
  test_ImgL := imgL.RemoveTestAndBuildNewImageList;

  AI_2022 := TPas_AI_TECH_2022.OpenEngine;
  Now_Finished_Button.TagObject := AI_2022;
  p := TPas_AI_TECH_2022.Init_YOLO_X_Parameter(umlCombineFileName(AI_Work_Path, '_143_YOLO_X_Training.sync'),
    umlCombineFileName(AI_Work_Path, '_143_YOLO_X_Training' + C_YOLO_X_Ext));

  AI_2022.SetComputeDeviceOfTraining([0]);
  AI_2022.YOLO_X_DNN_Train(p, imgL, test_ImgL);
  DisposeObject(AI_2022);

  DisposeObject(imgL);
  DisposeObject(test_ImgL);
  DoStatus('训练完成');
  TCompute.RunP_NP(procedure
    begin
      training_Button.Enabled := True;
      Now_Finished_Button.Enabled := False;
      Invalidate;
    end);
end;

procedure T_143_YOLO_X_Training_Form.Do_Remove_Train_Model;
begin

end;

procedure T_143_YOLO_X_Training_Form.Test_ButtonClick(Sender: TObject);
begin
  _143_YOLO_X_Test_Form.Show;
end;

end.
