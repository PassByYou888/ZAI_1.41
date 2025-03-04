unit ResNetImgClassifierFrm;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Controls.Presentation,
  FMX.StdCtrls, FMX.Objects, FMX.ScrollBox, FMX.Memo,

  System.IOUtils,

  PasAI.Core, PasAI.ListEngine,
  PasAI.Learn, PasAI.Learn.Type_LIB,
  PasAI.AI, PasAI.AI.Common, PasAI.AI.TrainingTask,
  PasAI.DrawEngine.SlowFMX, PasAI.DrawEngine, PasAI.Geometry2D, PasAI.MemoryRaster,
  PasAI.MemoryStream, PasAI.PascalStrings, PasAI.UnicodeMixedLib, PasAI.Status, FMX.Layouts, FMX.ExtCtrls,
  FMX.Memo.Types;

type
  TResNetImgClassifierForm = class(TForm)
    Training_IMGClassifier_Button: TButton;
    Memo1: TMemo;
    Timer1: TTimer;
    ResetButton: TButton;
    ImgClassifierDetectorButton: TButton;
    OpenDialog1: TOpenDialog;
    procedure ImgClassifierDetectorButtonClick(Sender: TObject);
    procedure Training_IMGClassifier_ButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ResetButtonClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    procedure DoStatusMethod(Text_: SystemString; const ID: Integer);
  public
    ai: TPas_AI;
    imgMat: TPas_AI_ImageMatrix;
  end;

var
  ResNetImgClassifierForm: TResNetImgClassifierForm;

implementation

{$R *.fmx}


procedure TResNetImgClassifierForm.ImgClassifierDetectorButtonClick(Sender: TObject);
begin
  OpenDialog1.Filter := TBitmapCodecManager.GetFilterString;
  if not OpenDialog1.Execute then
      exit;

  TComputeThread.RunP(nil, nil, procedure(Sender: TComputeThread)
    var
      sync_fn, output_fn, index_fn: U_String;
      mr: TMPasAI_Raster;
      rnic_hnd: TRNIC_Handle;
      rnic_index: TPascalStringList;
      rnic_vec: TLVec;
      i, index: Integer;
    begin
      output_fn := umlCombineFileName(TPath.GetLibraryPath, 'MiniImgClassifier' + C_RNIC_Ext);
      index_fn := umlCombineFileName(TPath.GetLibraryPath, 'MiniImgClassifier.index');

      if (not umlFileExists(output_fn)) or (not umlFileExists(index_fn)) then
        begin
          DoStatus('没有图片分类器的训练数据.');
          exit;
        end;

      mr := NewPasAI_RasterFromFile(OpenDialog1.FileName);
      rnic_hnd := ai.RNIC_Open_Stream(output_fn);
      rnic_index := TPascalStringList.Create;
      rnic_index.LoadFromFile(index_fn);

      // ZAI对cuda的支持机制说明：在1.4版本，使用ZAI的模型必须绑定线程，载入模型用的线程，在识别时要对应
      // 使用zAI的cuda必行保证在主进程中计算，否则会发生显存泄漏
      TThread.Synchronize(TThread.CurrentThread, procedure
        begin
          rnic_vec := ai.RNIC_Process(rnic_hnd, mr, 64);
        end);

      for i := 0 to rnic_index.Count - 1 do
        begin
          index := LMaxVecIndex(rnic_vec);
          if index < rnic_index.Count then
              DoStatus('%d - %s - %f', [i, rnic_index[index].Text, rnic_vec[index]])
          else
              DoStatus('索引与RNIC输出不匹配.需要重新训练');
          rnic_vec[index] := 0;
        end;

      ai.RNIC_Close(rnic_hnd);
      disposeObject(rnic_index);
      disposeObject(mr);
    end);
end;

procedure TResNetImgClassifierForm.Training_IMGClassifier_ButtonClick(Sender: TObject);
begin
  TComputeThread.RunP(nil, nil, procedure(Sender: TComputeThread)
    var
      param: PRNIC_Train_Parameter;
      sync_fn, output_fn, index_fn: U_String;
    begin
      TThread.Synchronize(Sender, procedure
        begin
          Training_IMGClassifier_Button.Enabled := False;
          ResetButton.Enabled := False;
        end);
      try
        sync_fn := umlCombineFileName(TPath.GetLibraryPath, 'MiniImgClassifier.imgMat.sync');
        output_fn := umlCombineFileName(TPath.GetLibraryPath, 'MiniImgClassifier' + C_RNIC_Ext);
        index_fn := umlCombineFileName(TPath.GetLibraryPath, 'MiniImgClassifier.index');

        if (not umlFileExists(output_fn)) or (not umlFileExists(index_fn)) then
          begin
            param := TPas_AI.Init_RNIC_Train_Parameter(sync_fn, output_fn);

            // 本次训练计划使用8小时
            param^.timeout := C_Tick_Hour * 8;

            // 收敛梯度的处理条件
            // 在收敛梯度中，只要失效步数高于该数值，梯度就会开始收敛
            param^.iterations_without_progress_threshold := 3000;

            // 这个数值是在输入net时使用的，简单来解释，这是可以滑动统计的参考尺度
            // 因为在图片分类器的训练中iterations_without_progress_threshold会很大
            // all_bn_running_stats_window_sizes可以限制在很大的迭代次数中，控制resnet在每次step mini batch的滑动size
            // all_bn_running_stats_window_sizes是降低训练时间而设计的超参
            param^.all_bn_running_stats_window_sizes := 1000;

            // 请参考od思路
            // resnet每次做step时的光栅输入批次
            // 根据gpu和内存的配置来设定即可
            param^.img_mini_batch := 4;

            // gpu每做一次批次运算会暂停的时间单位是ms
            // 这项参数是在1.15新增的呼吸参数，它可以让我们在工作的同时，后台进行无感觉训练
            PasAI.AI.KeepPerformanceOnTraining := 5;

            if ai.RNIC_Train(imgMat, param, index_fn) then
              begin
                DoStatus('训练成功.');
              end
            else
              begin
                DoStatus('训练失败.');
              end;

            TPas_AI.Free_RNIC_Train_Parameter(param);
          end
        else
            DoStatus('图片分类器已经训练过了.');
      finally
          TThread.Synchronize(Sender, procedure
          begin
            Training_IMGClassifier_Button.Enabled := True;
            ResetButton.Enabled := True;
          end);
      end;
    end);
end;

procedure TResNetImgClassifierForm.DoStatusMethod(Text_: SystemString; const ID: Integer);
begin
  Memo1.Lines.Add(Text_);
  Memo1.GoToTextEnd;
end;

procedure TResNetImgClassifierForm.FormCreate(Sender: TObject);
begin
  AddDoStatusHook(Self, DoStatusMethod);
  // 读取zAI的配置
  CheckAndReadAIConfig;
  PasAI.AI.Prepare_AI_Engine();

  TComputeThread.RunP(nil, nil, procedure(Sender: TComputeThread)
    var
      i, j: Integer;
      imgL: TPas_AI_ImageList;
      detDef: TPas_AI_DetectorDefine;
      tokens: TArrayPascalString;
      n: TPascalString;
    begin
      TThread.Synchronize(Sender, procedure
        begin
          Training_IMGClassifier_Button.Enabled := False;
          ResetButton.Enabled := False;
        end);
      ai := TPas_AI.OpenEngine();
      imgMat := TPas_AI_ImageMatrix.Create;
      DoStatus('正在读取分类图片矩阵库.');
      imgMat.LoadFromFile(umlCombineFileName(TPath.GetLibraryPath, 'MiniImgClassifier.imgMat'));

      DoStatus('矫正分类标签.');
      for i := 0 to imgMat.Count - 1 do
        begin
          imgL := imgMat[i];
          imgL.CalibrationNullToken(imgL.FileInfo);
          for j := 0 to imgL.Count - 1 do
            if imgL[j].DetectorDefineList.Count = 0 then
              begin
                detDef := TPas_AI_DetectorDefine.Create(imgL[j]);
                detDef.R := imgL[j].Raster.BoundsRect;
                detDef.Token := imgL.FileInfo;
                imgL[j].DetectorDefineList.Add(detDef);
              end;
        end;

      tokens := imgMat.DetectorTokens;
      DoStatus('总共有 %d 个分类', [length(tokens)]);
      for n in tokens do
          DoStatus('"%s" 有 %d 张图片', [n.Text, imgMat.GetDetectorTokenCount(n)]);

      TThread.Synchronize(Sender, procedure
        begin
          Training_IMGClassifier_Button.Enabled := True;
          ResetButton.Enabled := True;
        end);
    end);
end;

procedure TResNetImgClassifierForm.ResetButtonClick(Sender: TObject);
  procedure d(FileName: U_String);
  begin
    DoStatus('删除文件 %s', [FileName.Text]);
    umlDeleteFile(FileName);
  end;

begin
  d(umlCombineFileName(TPath.GetLibraryPath, 'MiniImgClassifier.imgMat.sync'));
  d(umlCombineFileName(TPath.GetLibraryPath, 'MiniImgClassifier.imgMat.sync_'));
  d(umlCombineFileName(TPath.GetLibraryPath, 'MiniImgClassifier' + C_RNIC_Ext));
  d(umlCombineFileName(TPath.GetLibraryPath, 'MiniImgClassifier.index'));
end;

procedure TResNetImgClassifierForm.Timer1Timer(Sender: TObject);
begin
  CheckThread;
  DoStatus;
end;

end.
