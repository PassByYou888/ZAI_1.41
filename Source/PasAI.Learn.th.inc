{ ****************************************************************************** }
{ * learn thread                                                               * }
{ ****************************************************************************** }
type
  TLearn_thread = class(TCore_Object_Intermediate)
  public
    Source: TLearn;
    TrainDepth: TLInt;
    OnStateC: TLearnState_C;
    OnStateM: TLearnState_M;
    OnStateP: TLearnState_P;
    Successed: Boolean;
    constructor Create;
    destructor Destroy; override;
    procedure SyncResultState;
    procedure Do_Execute;
    procedure Run;
  end;

constructor TLearn_thread.Create;
begin
  inherited Create;
  Source := nil;
  TrainDepth := 1;
  OnStateC := nil;
  OnStateM := nil;
  OnStateP := nil;
  Successed := False;
end;

destructor TLearn_thread.Destroy;
begin
  inherited Destroy;
end;

procedure TLearn_thread.SyncResultState;
begin
  Source.FTrainingThreadRuning := False;
  if Assigned(OnStateC) then
      OnStateC(Source, Successed)
  else if Assigned(OnStateM) then
      OnStateM(Source, Successed)
  else if Assigned(OnStateP) then
      OnStateP(Source, Successed);
end;

procedure TLearn_thread.Do_Execute;
begin
  if Source <> nil then
      Successed := Source.Training(TrainDepth)
  else
      Successed := False;

  TCompute.SyncM(SyncResultState);
  DelayFreeObj(1.0, Self);
end;

procedure TLearn_thread.Run;
begin
  TCompute.RunM_NP(Do_Execute);
end;
