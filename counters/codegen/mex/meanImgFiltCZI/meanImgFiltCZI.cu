/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * meanImgFiltCZI.cu
 *
 * Code generation for function 'meanImgFiltCZI'
 *
 */

/* Include files */
#include "MWCudaDimUtility.h"
#include "rt_nonfinite.h"
#include "meanImgFiltCZI.h"

/* Function Declarations */
static __global__ void meanImgFiltCZI_kernel1(real_T expanded[1052676]);
static __global__ void meanImgFiltCZI_kernel2(const real_T A[1048576], real_T
  expanded[1052676]);
static __global__ void meanImgFiltCZI_kernel3(real_T expanded[1052676], real_T
  B[1048576]);

/* Function Definitions */
static __global__ __launch_bounds__(512, 1) void meanImgFiltCZI_kernel1(real_T
  expanded[1052676])
{
  uint32_T threadId;
  int32_T ocol;
  threadId = (uint32_T)mwGetGlobalThreadIndex();
  ocol = (int32_T)threadId;
  if (ocol < 1052676) {
    expanded[ocol] = 0.0;
  }
}

static __global__ __launch_bounds__(512, 1) void meanImgFiltCZI_kernel2(const
  real_T A[1048576], real_T expanded[1052676])
{
  uint32_T threadId;
  int32_T k;
  int32_T ocol;
  threadId = (uint32_T)mwGetGlobalThreadIndex();
  k = (int32_T)(threadId % 1024U);
  ocol = (int32_T)((threadId - (uint32_T)k) / 1024U);
  if (ocol < 1024) {
    expanded[(k + 1026 * (1 + ocol)) + 1] = A[k + (ocol << 10)];
  }
}

static __global__ __launch_bounds__(1024, 1) void meanImgFiltCZI_kernel3(real_T
  expanded[1052676], real_T B[1048576])
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
      if (((int32_T)(((int32_T)(baseR >= 0)) && ((int32_T)(baseR < 1026)))) &&
          ((int32_T)(((int32_T)(baseC >= 0)) && ((int32_T)(baseC < 1026))))) {
        expanded_shared[y_idx + 34 * x_idx] = expanded[1026 * baseC + baseR];
      } else {
        expanded_shared[y_idx + 34 * x_idx] = 0.0;
      }

      baseC += strideCol;
    }

    baseR += strideRow;
  }

  __syncthreads();
  if (((int32_T)(ocol < 1024)) && ((int32_T)(orow < 1024))) {
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

    B[orow + (ocol << 10)] = y / 9.0;
  }
}

void meanImgFiltCZI(const real_T A[1048576], real_T B[1048576])
{
  real_T (*gpu_expanded)[1052676];
  real_T (*gpu_A)[1048576];
  real_T (*gpu_B)[1048576];
  cudaMalloc(&gpu_B, 8388608ULL);
  cudaMalloc(&gpu_A, 8388608ULL);
  cudaMalloc(&gpu_expanded, 8421408ULL);
  meanImgFiltCZI_kernel1<<<dim3(2057U, 1U, 1U), dim3(512U, 1U, 1U)>>>
    (*gpu_expanded);
  cudaMemcpy(gpu_A, (void *)&A[0], 8388608ULL, cudaMemcpyHostToDevice);
  meanImgFiltCZI_kernel2<<<dim3(2048U, 1U, 1U), dim3(512U, 1U, 1U)>>>(*gpu_A,
    *gpu_expanded);
  meanImgFiltCZI_kernel3<<<dim3(32U, 32U, 1U), dim3(32U, 32U, 1U)>>>
    (*gpu_expanded, *gpu_B);
  cudaMemcpy(&B[0], gpu_B, 8388608ULL, cudaMemcpyDeviceToHost);
  cudaFree(*gpu_expanded);
  cudaFree(*gpu_A);
  cudaFree(*gpu_B);
}

/* End of code generation (meanImgFiltCZI.cu) */
