/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * meanImgFiltCZI_terminate.cu
 *
 * Code generation for function 'meanImgFiltCZI_terminate'
 *
 */

/* Include files */
#include "rt_nonfinite.h"
#include "meanImgFiltCZI.h"
#include "meanImgFiltCZI_terminate.h"
#include "_coder_meanImgFiltCZI_mex.h"
#include "meanImgFiltCZI_data.h"

/* Function Definitions */
void meanImgFiltCZI_atexit()
{
  mexFunctionCreateRootTLS();
  emlrtEnterRtStackR2012b(emlrtRootTLSGlobal);
  emlrtLeaveRtStackR2012b(emlrtRootTLSGlobal);
  emlrtDestroyRootTLS(&emlrtRootTLSGlobal);
}

void meanImgFiltCZI_terminate()
{
  emlrtLeaveRtStackR2012b(emlrtRootTLSGlobal);
  emlrtDestroyRootTLS(&emlrtRootTLSGlobal);
}

/* End of code generation (meanImgFiltCZI_terminate.cu) */
