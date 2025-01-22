unit _156_SSL_Trainer_Frm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,

  IOUtils,

  PasAI.Core,
  PasAI.PascalStrings, PasAI.UPascalStrings,
  PasAI.MemoryStream, PasAI.UnicodeMixedLib, PasAI.DFE, PasAI.ListEngine, PasAI.TextDataEngine, PasAI.Parsing, PasAI.Expression, PasAI.OpCode,
  PasAI.HashList.Templet,
  PasAI.ZDB, PasAI.ZDB.ObjectData_LIB, PasAI.ZDB.ItemStream_LIB, PasAI.Status,
  PasAI.DrawEngine, PasAI.Geometry2D, PasAI.MemoryRaster, PasAI.Learn.Type_LIB, PasAI.Learn, PasAI.Learn.KDTree, PasAI.Learn.SIFT,
  PasAI.AI.Common, PasAI.AI.TrainingTask,
  PasAI.AI, PasAI.AI.Tech2022;

type
  T_156_SSL_Trainer_Form = class(TForm)
    sysTimer: TTimer;
    Memo: TMemo;
    Training_ImageList_Button: TButton;
    stop_Button: TButton;
    Button1: TButton;
    jitter_num_Edit: TLabeledEdit;
    model_info_Button: TButton;
    OpenDialog: TOpenDialog;
    procedure Button1Click(Sender: TObject);
    procedure model_info_ButtonClick(Sender: TObject);
    procedure stop_ButtonClick(Sender: TObject);
    procedure sysTimerTimer(Sender: TObject);
    procedure Training_ImageList_ButtonClick(Sender: TObject);
  private
    procedure DoStatus_backcall(Text_: SystemString; const ID: Integer);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure Do_Training;
  end;

var
  _156_SSL_Trainer_Form: T_156_SSL_Trainer_Form;
  ai_2022: TPas_AI_TECH_2022;

implementation

{$R *.dfm}


procedure T_156_SSL_Trainer_Form.sysTimerTimer(Sender: TObject);
begin
  Check_Soft_Thread_Synchronize;
end;

procedure T_156_SSL_Trainer_Form.Training_ImageList_ButtonClick(Sender: TObject);
begin
  TCompute.RunM_NP(Do_Training);
end;

constructor T_156_SSL_Trainer_Form.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  AddDoStatusHook(self, DoStatus_backcall);
  ReadAIConfig();
  ai_2022 := TPas_AI_TECH_2022.OpenEngine;
end;

destructor T_156_SSL_Trainer_Form.Destroy;
begin
  RemoveDoStatusHook(self);
  inherited Destroy;
end;

procedure T_156_SSL_Trainer_Form.Button1Click(Sender: TObject);
var
  fn: U_String;
  hnd: TPas_AI_TECH_2022_SSL_Handle;
  raster: TPasAI_Raster;
  output_sampling: TArrayV2R4;
  mat: TLMatrix;
  i: Integer;
begin
  fn := WhereFileFromConfigure('SSL_Trainer_Demo' + C_SSL_Ext);
  if not umlFileExists(fn) then
      exit;
  hnd := ai_2022.SSL_Open(fn);

  if not OpenDialog.Execute then
      exit;

  raster := NewPasAI_RasterFromFile(OpenDialog.FileName);
  mat := ai_2022.SSL_Process(hnd, raster, False, EStrToInt(jitter_num_Edit.Text), output_sampling);
  for i := 0 to length(mat) - 1 do
      DoStatus(inttostr(i) + ': ' + LVec(mat[i], True) + #13#10);
  ai_2022.SSL_Close(hnd);
end;

procedure T_156_SSL_Trainer_Form.model_info_ButtonClick(Sender: TObject);
var
  fn: U_String;
  hnd: TPas_AI_TECH_2022_SSL_Handle;
begin
  fn := WhereFileFromConfigure('SSL_Trainer_Demo' + C_SSL_Ext);
  if not umlFileExists(fn) then
      exit;
  hnd := ai_2022.SSL_Open(fn);
  DoStatus(ai_2022.SSL_DebugInfo(hnd));
  ai_2022.SSL_Close(hnd);
end;

procedure T_156_SSL_Trainer_Form.DoStatus_backcall(Text_: SystemString; const ID: Integer);
begin
  Memo.Lines.Add(Text_);
end;

procedure T_156_SSL_Trainer_Form.Do_Training;
var
  imgL: TPas_AI_ImageList;
  param: PPas_AI_TECH_2022_SSL_Train_Parameter;
  m64: TMS64;
  L: TLearn;
begin
  imgL := TPas_AI_ImageList.Create;
  imgL.LoadFromFile(WhereFileFromConfigure('bear.ImgDataSet'));

  param := TPas_AI_TECH_2022.Init_SSL_Parameter(
    umlCombineFileName(TPath.GetLibraryPath, 'SSL_Trainer_Demo' + C_Sync_Ext),
    umlCombineFileName(TPath.GetLibraryPath, 'SSL_Trainer_Demo' + C_SSL_Ext));

  m64 := ai_2022.SSL_Train_Stream(imgL, param);

  if m64 <> nil then
    begin
      L := TPas_AI_TECH_2022.Build_SSL_Learn;
      ai_2022.SSL_Save_To_Learn_DNN_Thread(100, 4, m64, imgL, L);
      L.Training;
      L.SaveToFile(umlCombineFileName(TPath.GetLibraryPath, 'SSL_Trainer_Demo' + C_Learn_Ext));
      DisposeObject(L);
    end
  else
    begin
    end;

  TPas_AI_TECH_2022.Free_SSL_Parameter(param);
  DisposeObject(imgL);
end;

procedure T_156_SSL_Trainer_Form.stop_ButtonClick(Sender: TObject);
begin
  ai_2022.Training_Stop;
end;

end.
