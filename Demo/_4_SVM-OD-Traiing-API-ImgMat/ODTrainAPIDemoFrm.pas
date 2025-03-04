unit ODTrainAPIDemoFrm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,

  System.IOUtils, Vcl.ExtCtrls,

  PasAI.Core, PasAI.PascalStrings, PasAI.UnicodeMixedLib, PasAI.AI, PasAI.AI.Common, PasAI.AI.TrainingTask,
  PasAI.ListEngine, PasAI.DrawEngine.SlowFMX, PasAI.MemoryRaster, PasAI.Status, PasAI.MemoryStream;

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
      // AI引擎
      ai: TPas_AI;
      // 时间刻度变量
      dt: TTimeTick;
      imgMat: TPas_AI_ImageMatrix;
      m64: TMS64;
    begin
      TThread.Synchronize(Sender, procedure
        begin
          fn := umlCombineFileName(TPath.GetLibraryPath, FileEdit.Text);
        end);

      // imgMat是图片矩阵，用于处理大规模图片数据集的训练
      imgMat := TPas_AI_ImageMatrix.Create;

      // 由于图片矩阵在读取和保存大型图片集非常慢，一般来说，一次读取和保存都是数十万张，这里的操作要谨慎
      // 图片矩阵的保存和读取，都是并行化的，会将cpu吃满，然后让磁盘IO满负荷工作，以减少等待时间
      imgMat.LoadFromFile(fn);

      // 缩小数据集尺寸，提高OD训练速度
      DoStatus('调整数据集尺寸');
      imgMat.Scale(0.5);

      // 构建zAI的引擎
      // zAI引擎可以在线程中直接构建，不用Sync
      ai := TPas_AI.OpenEngine();

      DoStatus('开始训练');
      // 后台训练
      dt := GetTimeTick();

      // 开始训练图片库矩阵
      // 我们训练大规模样本时，都应该选择图片矩阵方式来训练
      m64 := ai.OD6L_Marshal_Train(imgMat, 100, 100, 8);

      if m64 <> nil then
        begin
          DoStatus('训练成功.耗时 %d 毫秒', [GetTimeTick() - dt]);
          TThread.Synchronize(Sender, procedure
            begin
              // 当训练完成后，我们将训练好的数据保存
              SaveDialog.FileName := 'output' + C_OD6L_Marshal_Ext;
              if not SaveDialog.Execute() then
                  exit;

              // 使用.svm_od数据，请参考SVM_OD的Demo
              m64.SaveToFile(SaveDialog.FileName);
            end);
          DisposeObject(m64);
        end
      else
          DoStatus('训练失败.');

      // 释放训练使用的数据
      DisposeObject(ai);
      DisposeObject(imgMat);

    end);
end;

end.
