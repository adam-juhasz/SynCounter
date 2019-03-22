/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * meanImgFiltLSM.cu
 *
 * Code generation for function 'meanImgFiltLSM'
 *
 */

/* Include files */
#include "MWCudaDimUtility.h"
#include "rt_nonfinite.h"
#include "meanImgFiltLSM.h"

/* Function Declarations */
static __global__ void meanImgFiltLSM_kernel1(real_T expanded[509796]);
static __global__ void meanImgFiltLSM_kernel2(const real_T A[506944], real_T
  expanded[509796]);
static __global__ void meanImgFiltLSM_kernel3(real_T expanded[509796], real_T B
  [506944]);

/* Function Definitions */
static __global__ __launch_bounds__(512, 1) void meanImgFiltLSM_kernel1(real_T
  expanded[509796])
{
  uint32_T threadId;
  int32_T ocol;
  threadId = (uint32_T)mwGetGlobalThreadIndex();
  ocol = (int32_T)threadId;
  if (ocol < 509796) {
    expanded[ocol] = 0.0;
  }
}

static __global__ __launch_bounds__(512, 1) void meanImgFiltLSM_kernel2(const
  real_T A[506944], real_T expanded[509796])
{
  uint32_T threadId;
  int32_T k;
  int32_T ocol;
  threadId = (uint32_T)mwGetGlobalThreadIndex();
  k = (int32_T)(threadId % 712U);
  ocol = (int32_T)((threadId - (uint32_T)k) / 712U);
  if (ocol < 712) {
    expanded[(k + 714 * (1 + ocol)) + 1] = A[k + 712 * ocol];
  }
}

static __global__ __launch_bounds__(1024, 1) void meanImgFiltLSM_kernel3(real_T
  expanded[509796], real_T B[506944])
{
  real_T y;
  int32_T orow;
  int32_T ocol;
  int32_T k;
  __shared__ real_T expanded_shared[1156];
  int32_T baseR;
  int32_T srow;
  int32_T strideRow;
  int32_T scol;
  int32_T strideCol;
  int32_T y_idx;
  int32_T baseC;
  int32_T x_idx;
  ocol = mwGetGlobalThreadIndexInYDimension();
  orow = mwGetGlobalThreadIndexInXDimension();
  baseR = orow;
  srow = (int32_T)threadIdx.x;
  strideRow = (int32_T)blockDim.x;
  scol = (int32_T)threadIdx.y;
  strideCol = (int32_T)blockDim.y;
  for (y_idx = srow; y_idx <= 33; y_idx += strideRow) {
    baseC = ocol;
    for (x_idx = scol; x_idx <= 33; x_idx += strideCol) {
      if (((int32_T)(((int32_T)(baseR >= 0)) && ((int32_T)(baseR < 714)))) &&
          ((int32_T)(((int32_T)(baseC >= 0)) && ((int32_T)(baseC < 714))))) {
        expanded_shared[y_idx + 34 * x_idx] = expanded[714 * baseC + baseR];
      } else {
        expanded_shared[y_idx + 34 * x_idx] = 0.0;
      }

      baseC += strideCol;
    }

    baseR += strideRow;
  }

  __syncthreads();
  if (((int32_T)(ocol < 712)) && ((int32_T)(orow < 712))) {
    y = expanded_shared[((int32_T)threadIdx.x +
                         (mwGetGlobalThreadIndexInXDimension() -
                          mwGetGlobalThreadIndexInXDimension())) + 34 *
      ((int32_T)threadIdx.y + (mwGetGlobalThreadIndexInYDimension() -
        mwGetGlobalThreadIndexInYDimension()))];
    for (k = 0; k < 8; k++) {
      y += expanded_shared[((int32_T)threadIdx.x + (((k + 1) % 3 +
        mwGetGlobalThreadIndexInXDimension()) -
        mwGetGlobalThreadIndexInXDimension())) + 34 * ((int32_T)threadIdx.y +
        (((k + 1) / 3 + mwGetGlobalThreadIndexInYDimension()) -
         mwGetGlobalThreadIndexInYDimension()))];
    }

    B[orow + 712 * ocol] = y / 9.0;
  }
}

void meanImgFiltLSM(const real_T A[506944], real_T B[506944])
{
  real_T (*gpu_expanded)[509796];
  real_T (*gpu_A)[506944];
  real_T (*gpu_B)[506944];
  cudaMalloc(&gpu_B, 4055552ULL);
  cudaMalloc(&gpu_A, 4055552ULL);
  cudaMalloc(&gpu_expanded, 4078368ULL);
  meanImgFiltLSM_kernel1<<<dim3(996U, 1U, 1U), dim3(512U, 1U, 1U)>>>
    (*gpu_expanded);
  cudaMemcpy(gpu_A, (void *)&A[0], 4055552ULL, cudaMemcpyHostToDevice);
  meanImgFiltLSM_kernel2<<<dim3(991U, 1U, 1U), dim3(512U, 1U, 1U)>>>(*gpu_A,
    *gpu_expanded);
  meanImgFiltLSM_kernel3<<<dim3(23U, 23U, 1U), dim3(32U, 32U, 1U)>>>
    (*gpu_expanded, *gpu_B);
  cudaMemcpy(&B[0], gpu_B, 4055552ULL, cudaMemcpyDeviceToHost);
  cudaFree(*gpu_expanded);
  cudaFree(*gpu_A);
  cudaFree(*gpu_B);
}

/* End of code generation (meanImgFiltLSM.cu) */
