unit ODTrainAPIDemoFrm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,

  System.IOUtils,

  PasAI.Core, PasAI.PascalStrings, PasAI.UnicodeMixedLib, PasAI.AI, PasAI.AI.Common, PasAI.AI.TrainingTask,
  PasAI.ListEngine, PasAI.DrawEngine.SlowFMX, PasAI.MemoryRaster, PasAI.Status;

type
  TForm2 = class(TForm)
    Memo1: TMemo;
    FileEdit: TLabeledEdit;
    trainingButton: TButton;
    SaveDialog: TSaveDialog;
    Timer1: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure trainingButtonClick(Sender: TObject);
  private
    { Private declarations }
    procedure DoStatusMethod(Text_: SystemString; const ID: Integer);
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

{$R *.dfm}


procedure TForm2.DoStatusMethod(Text_: SystemString; const ID: Integer);
begin
  Memo1.Lines.Add(Text_);
end;

procedure TForm2.FormCreate(Sender: TObject);
begin
  AddDoStatusHook(Self, DoStatusMethod);
  // 读取zAI的配置
  CheckAndReadAIConfig;
  PasAI.AI.Prepare_AI_Engine();
end;

procedure TForm2.Timer1Timer(Sender: TObject);
begin
  CheckThread;
  // dostatus不给参数，是刷新在线程中的StatusIO状态，可以刷新parallel线程中的status
  DoStatus;
end;

procedure TForm2.trainingButtonClick(Sender: TObject);
begin
  TComputeThread.RunP(nil, nil,
    procedure(Sender: TComputeThread)
    var
      fn: U_String;
      // 训练引擎
      tt: TPas_AI_TrainingTask;
      // 训练参数
      param: THashVariantList;
      // AI引擎
      ai: TPas_AI;
      // 时间刻度变量
      dt: TTimeTick;
      report: SystemString;
    begin
      TThread.Synchronize(Sender, procedure
        begin
          fn := umlCombineFileName(TPath.GetLibraryPath, FileEdit.Text);
        end);
      tt := TPas_AI_TrainingTask.CreateMemoryTask;

      // 将文件写入训练任务
      tt.WriteFile(umlGetFileName(fn), fn);

      // 构建训练参数
      param := THashVariantList.Create;
      param.SetDefaultValue('ComputeFunc', 'TrainOD');      // 指定训练函数
      param.SetDefaultValue('source', umlGetFileName(fn));  // 输入的数据是bear.imgDataset
      param.SetDefaultValue('window_width', 100);           // 训练完成后，窗口滑动用，检测尺度宽，如果训练给高清图像用，这里就给100或则更大，低分辨率图像用，这里就给小
      param.SetDefaultValue('window_height', 100);          // 训练完成后，窗口滑动用，检测尺度高，如果训练给高清图像用，这里就给100或则更大，低分辨率图像用，这里就给小
      param.SetDefaultValue('thread', 8);                   // 并行训练的线程数量
      param.SetDefaultValue('scale', 0.5);                  // 缩放系数，0.5可以有效提升训练速度
      param.SetDefaultValue('output', 'output' + C_OD6L_Ext); // 训练完成后的输出文件

      tt.Write('param.txt', param);

      DoStatus('训练参数.');
      DoStatus(param.AsText);

      DoStatus('检测训练数据 ');
      if tt.CheckTrainingBefore('param.txt', report) then
        begin
          DoStatus(report);

          // 构建zAI的引擎
          // zAI引擎可以在线程中直接构建，不用Sync
          ai := TPas_AI.OpenEngine();

          DoStatus('开始训练');
          // 后台训练
          dt := GetTimeTick();
          if RunTrainingTask(tt, ai, 'param.txt') then
            begin
              DoStatus('训练成功.耗时 %d 毫秒', [GetTimeTick() - dt]);
              TThread.Synchronize(Sender, procedure
                begin
                  // 当训练完成后，我们将训练好的数据保存
                  SaveDialog.FileName := param.GetDefaultValue('output', 'output' + C_OD6L_Ext);
                  if not SaveDialog.Execute() then
                      exit;

                  // 使用.svm_od数据，请参考SVM_OD的Demo
                  tt.ReadToFile(param.GetDefaultValue('output', 'output' + C_OD6L_Ext), SaveDialog.FileName);
                end);
            end
          else
              DoStatus('训练失败.');

          // 释放训练使用的数据
          disposeObject(ai);
        end
      else
        begin
          DoStatus(report);
        end;

      disposeObject(tt);
      disposeObject(param);
    end);
end;

end.
