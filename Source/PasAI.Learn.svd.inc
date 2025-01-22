{ ****************************************************************************** }
{ * Singular value decomposition                                               * }
{ ****************************************************************************** }

(* ************************************************************************
  Singular value decomposition of a rectangular matrix.

  The algorithm calculates the singular value decomposition of a matrix of
  size MxN: A = U * S * V^T

  The algorithm finds the singular values and, optionally, matrices U and V^T.
  The algorithm can find both first min(M,N) columns of matrix U and rows of
  matrix V^T (singular vectors), and matrices U and V^T wholly (of sizes MxM
  and NxN respectively).

  Take into account that the subroutine does not return matrix V but V^T.

  Input parameters:
  A           -   matrix to be decomposed.
  Array whose indexes range within [0..M-1, 0..N-1].
  M           -   number of rows in matrix A.
  N           -   number of columns in matrix A.
  UNeeded     -   0, 1 or 2. See the description of the parameter U.
  VTNeeded    -   0, 1 or 2. See the description of the parameter VT.

  AdditionalMemory -
  If the parameter:
  * equals 0, the algorithm dont use additional memory (lower requirements, lower performance).
  * equals 1, the algorithm uses additional memory of size min(M,N)*min(M,N) of real numbers. It often speeds up the algorithm.
  * equals 2, the algorithm uses additional memory of size M*min(M,N) of real numbers.
  It allows to get a maximum performance. The recommended value of the parameter is 2.

  Output parameters:
  W           -   contains singular values in descending order.
  U           -   if UNeeded=0, U isn't changed, the left singular vectors are not calculated.
  if Uneeded=1, U contains left singular vectors (first min(M,N) columns of matrix U). Array whose indexes range within [0..M-1, 0..Min(M,N)-1].
  if UNeeded=2, U contains matrix U wholly. Array whose indexes range within [0..M-1, 0..M-1].
  VT          -   if VTNeeded=0, VT isn't changed, the right singular vectors are not calculated.
  if VTNeeded=1, VT contains right singular vectors (first min(M,N) rows of matrix V^T). Array whose indexes range within [0..min(M,N)-1, 0..N-1].
  if VTNeeded=2, VT contains matrix V^T wholly. Array whose indexes range within [0..N-1, 0..N-1].
  ************************************************************************ *)
function RMatrixSVD(a: TLMatrix; const M, N, UNeeded, VTNeeded, AdditionalMemory: TLInt; var W: TLVec; var U: TLMatrix; var VT: TLMatrix): Boolean;
var
  TauQ: TLVec;
  TauP: TLVec;
  TAU: TLVec;
  E: TLVec;
  Work: TLVec;
  t2: TLMatrix;
  IsUpper: Boolean;
  MinMN: TLInt;
  NCU: TLInt;
  NRVT: TLInt;
  NRU: TLInt;
  NCVT: TLInt;
  i: TLInt;
  j: TLInt;
begin
  a := DynamicArrayCopy(a);
  Result := True;
  if (M = 0) or (N = 0) then
    begin
      Exit;
    end;
  Assert((UNeeded >= 0) and (UNeeded <= 2), 'SVDDecomposition: wrong parameters!');
  Assert((VTNeeded >= 0) and (VTNeeded <= 2), 'SVDDecomposition: wrong parameters!');
  Assert((AdditionalMemory >= 0) and (AdditionalMemory <= 2), 'SVDDecomposition: wrong parameters!');

  //
  // initialize
  //
  MinMN := Min(M, N);
  SetLength(W, MinMN + 1);
  NCU := 0;
  NRU := 0;
  if UNeeded = 1 then
    begin
      NRU := M;
      NCU := MinMN;
      SetLength(U, NRU, NCU);
    end;
  if UNeeded = 2 then
    begin
      NRU := M;
      NCU := M;
      SetLength(U, NRU, NCU);
    end;
  NRVT := 0;
  NCVT := 0;
  if VTNeeded = 1 then
    begin
      NRVT := MinMN;
      NCVT := N;
      SetLength(VT, NRVT, NCVT);
    end;
  if VTNeeded = 2 then
    begin
      NRVT := N;
      NCVT := N;
      SetLength(VT, NRVT, NCVT);
    end;

  //
  // M much larger than N
  // Use bidiagonal reduction with QR-decomposition
  //
  if AP_FP_Greater(M, 1.6 * N) then
    begin
      if UNeeded = 0 then
        begin

          //
          // No left singular vectors to be computed
          //
          RMatrixQR(a, M, N, TAU);
          i := 0;
          while i <= N - 1 do
            begin
              j := 0;
              while j <= i - 1 do
                begin
                  a[i, j] := 0;
                  inc(j);
                end;
              inc(i);
            end;
          RMatrixBD(a, N, N, TauQ, TauP);
          RMatrixBDUnpackPT(a, N, N, TauP, NRVT, VT);
          RMatrixBDUnpackDiagonals(a, N, N, IsUpper, W, E);
          Result := RMatrixBDSVD(W, E, N, IsUpper, False, U, 0, a, 0, VT, NCVT);
          Exit;
        end
      else
        begin

          //
          // Left singular vectors (may be full matrix U) to be computed
          //
          RMatrixQR(a, M, N, TAU);
          RMatrixQRUnpackQ(a, M, N, TAU, NCU, U);
          i := 0;
          while i <= N - 1 do
            begin
              j := 0;
              while j <= i - 1 do
                begin
                  a[i, j] := 0;
                  inc(j);
                end;
              inc(i);
            end;
          RMatrixBD(a, N, N, TauQ, TauP);
          RMatrixBDUnpackPT(a, N, N, TauP, NRVT, VT);
          RMatrixBDUnpackDiagonals(a, N, N, IsUpper, W, E);
          if AdditionalMemory < 1 then
            begin

              //
              // No additional memory can be used
              //
              RMatrixBDMultiplyByQ(a, N, N, TauQ, U, M, N, True, False);
              Result := RMatrixBDSVD(W, E, N, IsUpper, False, U, M, a, 0, VT, NCVT);
            end
          else
            begin

              //
              // Large U. Transforming intermediate matrix T2
              //
              SetLength(Work, Max(M, N) + 1);
              RMatrixBDUnpackQ(a, N, N, TauQ, N, t2);
              CopyMatrix(U, 0, M - 1, 0, N - 1, a, 0, M - 1, 0, N - 1);
              InplaceTranspose(t2, 0, N - 1, 0, N - 1, Work);
              Result := RMatrixBDSVD(W, E, N, IsUpper, False, U, 0, t2, N, VT, NCVT);
              MatrixMatrixMultiply(a, 0, M - 1, 0, N - 1, False, t2, 0, N - 1, 0,
                N - 1, True, 1.0, U, 0, M - 1, 0, N - 1, 0.0, Work);
            end;
          Exit;
        end;
    end;

  //
  // N much larger than M
  // Use bidiagonal reduction with LQ-decomposition
  //
  if AP_FP_Greater(N, 1.6 * M) then
    begin
      if VTNeeded = 0 then
        begin

          //
          // No right singular vectors to be computed
          //
          RMatrixLQ(a, M, N, TAU);
          i := 0;
          while i <= M - 1 do
            begin
              j := i + 1;
              while j <= M - 1 do
                begin
                  a[i, j] := 0;
                  inc(j);
                end;
              inc(i);
            end;
          RMatrixBD(a, M, M, TauQ, TauP);
          RMatrixBDUnpackQ(a, M, M, TauQ, NCU, U);
          RMatrixBDUnpackDiagonals(a, M, M, IsUpper, W, E);
          SetLength(Work, M + 1);
          InplaceTranspose(U, 0, NRU - 1, 0, NCU - 1, Work);
          Result := RMatrixBDSVD(W, E, M, IsUpper, False, a, 0, U, NRU, VT, 0);
          InplaceTranspose(U, 0, NRU - 1, 0, NCU - 1, Work);
          Exit;
        end
      else
        begin

          //
          // Right singular vectors (may be full matrix VT) to be computed
          //
          RMatrixLQ(a, M, N, TAU);
          RMatrixLQUnpackQ(a, M, N, TAU, NRVT, VT);
          i := 0;
          while i <= M - 1 do
            begin
              j := i + 1;
              while j <= M - 1 do
                begin
                  a[i, j] := 0;
                  inc(j);
                end;
              inc(i);
            end;
          RMatrixBD(a, M, M, TauQ, TauP);
          RMatrixBDUnpackQ(a, M, M, TauQ, NCU, U);
          RMatrixBDUnpackDiagonals(a, M, M, IsUpper, W, E);
          SetLength(Work, Max(M, N) + 1);
          InplaceTranspose(U, 0, NRU - 1, 0, NCU - 1, Work);
          if AdditionalMemory < 1 then
            begin

              //
              // No additional memory available
              //
              RMatrixBDMultiplyByP(a, M, M, TauP, VT, M, N, False, True);
              Result := RMatrixBDSVD(W, E, M, IsUpper, False, a, 0, U, NRU, VT, N);
            end
          else
            begin

              //
              // Large VT. Transforming intermediate matrix T2
              //
              RMatrixBDUnpackPT(a, M, M, TauP, M, t2);
              Result := RMatrixBDSVD(W, E, M, IsUpper, False, a, 0, U, NRU, t2, M);
              CopyMatrix(VT, 0, M - 1, 0, N - 1, a, 0, M - 1, 0, N - 1);
              MatrixMatrixMultiply(t2, 0, M - 1, 0, M - 1, False, a, 0, M - 1, 0,
                N - 1, False, 1.0, VT, 0, M - 1, 0, N - 1, 0.0, Work);
            end;
          InplaceTranspose(U, 0, NRU - 1, 0, NCU - 1, Work);
          Exit;
        end;
    end;

  //
  // M<=N
  // We can use inplace transposition of U to get rid of columnwise operations
  //
  if M <= N then
    begin
      RMatrixBD(a, M, N, TauQ, TauP);
      RMatrixBDUnpackQ(a, M, N, TauQ, NCU, U);
      RMatrixBDUnpackPT(a, M, N, TauP, NRVT, VT);
      RMatrixBDUnpackDiagonals(a, M, N, IsUpper, W, E);
      SetLength(Work, M + 1);
      InplaceTranspose(U, 0, NRU - 1, 0, NCU - 1, Work);
      Result := RMatrixBDSVD(W, E, MinMN, IsUpper, False, a, 0, U, NRU, VT, NCVT);
      InplaceTranspose(U, 0, NRU - 1, 0, NCU - 1, Work);
      Exit;
    end;

  //
  // Simple bidiagonal reduction
  //
  RMatrixBD(a, M, N, TauQ, TauP);
  RMatrixBDUnpackQ(a, M, N, TauQ, NCU, U);
  RMatrixBDUnpackPT(a, M, N, TauP, NRVT, VT);
  RMatrixBDUnpackDiagonals(a, M, N, IsUpper, W, E);
  if (AdditionalMemory < 2) or (UNeeded = 0) then
    begin

      //
      // We cant use additional memory or there is no need in such operations
      //
      Result := RMatrixBDSVD(W, E, MinMN, IsUpper, False, U, NRU, a, 0, VT, NCVT);
    end
  else
    begin

      //
      // We can use additional memory
      //
      SetLength(t2, MinMN, M);
      CopyAndTranspose(U, 0, M - 1, 0, MinMN - 1, t2, 0, MinMN - 1, 0, M - 1);
      Result := RMatrixBDSVD(W, E, MinMN, IsUpper, False, U, 0, t2, M, VT, NCVT);
      CopyAndTranspose(t2, 0, MinMN - 1, 0, M - 1, U, 0, M - 1, 0, MinMN - 1);
    end;
end;
