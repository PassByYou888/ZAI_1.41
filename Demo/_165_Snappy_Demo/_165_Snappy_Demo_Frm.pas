unit _165_Snappy_Demo_Frm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,

  PasAI.Core, PasAI.PascalStrings, PasAI.UPascalStrings, PasAI.UnicodeMixedLib, PasAI.Status,
  PasAI.MemoryStream, PasAI.Snappy, Vcl.ExtCtrls;

type
  T_165_Snappy_Demo_Form = class(TForm)
    Memo: TMemo;
    Snappy_Compression_Button: TButton;
    Snappy_Uncompression_Button: TButton;
    sysTimer: TTimer;
    procedure sysTimerTimer(Sender: TObject);
    procedure Snappy_Compression_ButtonClick(Sender: TObject);
    procedure Snappy_Uncompression_ButtonClick(Sender: TObject);
  private
    procedure DoStatus_backcall(Text_: SystemString; const ID: Integer);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

var
  _165_Snappy_Demo_Form: T_165_Snappy_Demo_Form;

implementation

{$R *.dfm}


procedure T_165_Snappy_Demo_Form.sysTimerTimer(Sender: TObject);
begin
  CheckThread;
end;

procedure T_165_Snappy_Demo_Form.Snappy_Compression_ButtonClick(Sender: TObject);
begin
  TCompute.RunP_NP(procedure
    var
      m64: TMS64;
      Comp: TMS64;
      tk: TTimeTick;
      size: Int64;
    begin
      m64 := TMS64.Create;
      Comp := TMS64.Create;

      m64.SetSize(1024 * 1024);
      FillPtrByte(m64.Memory, m64.size, 0);

      DoStatus('测试snappy压缩,耗时大约5秒');

      size := 0;
      tk := GetTimeTick;
      while GetTimeTick - tk < 5000 do
        begin
          // snappy压缩在Z系都是基于TMS64/TMem64工作,不建议直接操作API,snappy压缩有预置尺度概念,实际使用需要配合MM内存管理器才能得到最优效率
          if m64.snappy_compress_To(Comp) then
              inc(size, m64.size);
        end;

      DoStatus('压缩器每秒数据流量:%s', [umlSizeToStr(size div 5).Text]);

      disposeObject(m64);
      disposeObject(Comp);
    end);
end;

procedure T_165_Snappy_Demo_Form.Snappy_Uncompression_ButtonClick(Sender: TObject);
begin
  TCompute.RunP_NP(procedure
    var
      m64: TMS64;
      Comp: TMS64;
      UnComp: TMS64;
      tk: TTimeTick;
      size: Int64;
    begin
      m64 := TMS64.Create;
      Comp := TMS64.Create;
      UnComp := TMS64.Create;

      // 生成压缩数据
      m64.SetSize(1024 * 1024);
      FillPtrByte(m64.Memory, m64.size, 0);
      m64.snappy_compress_To(Comp);

      DoStatus('测试snappy解压缩,耗时大约5秒');

      size := 0;
      tk := GetTimeTick;
      while GetTimeTick - tk < 5000 do
        begin
          if Comp.snappy_uncompress_To(UnComp) then
              inc(size, UnComp.size);
        end;

      DoStatus('解压缩每秒数据流量:%s', [umlSizeToStr(size div 5).Text]);

      disposeObject(m64);
      disposeObject(Comp);
      disposeObject(UnComp);
    end);
end;

procedure T_165_Snappy_Demo_Form.DoStatus_backcall(Text_: SystemString; const ID: Integer);
begin
  Memo.Lines.Add(Text_);
end;

constructor T_165_Snappy_Demo_Form.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  AddDoStatusHook(self, DoStatus_backcall);
end;

destructor T_165_Snappy_Demo_Form.Destroy;
begin
  RemoveDoStatusHook(self);
  inherited Destroy;
end;

end.
