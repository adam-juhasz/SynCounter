/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * meanImgFiltLSM_terminate.cu
 *
 * Code generation for function 'meanImgFiltLSM_terminate'
 *
 */

/* Include files */
#include "rt_nonfinite.h"
#include "meanImgFiltLSM.h"
#include "meanImgFiltLSM_terminate.h"
#include "_coder_meanImgFiltLSM_mex.h"
#include "meanImgFiltLSM_data.h"

/* Function Definitions */
void meanImgFiltLSM_atexit()
{
  mexFunctionCreateRootTLS();
  emlrtEnterRtStackR2012b(emlrtRootTLSGlobal);
  emlrtLeaveRtStackR2012b(emlrtRootTLSGlobal);
  emlrtDestroyRootTLS(&emlrtRootTLSGlobal);
}

void meanImgFiltLSM_terminate()
{
  emlrtLeaveRtStackR2012b(emlrtRootTLSGlobal);
  emlrtDestroyRootTLS(&emlrtRootTLSGlobal);
}

/* End of code generation (meanImgFiltLSM_terminate.cu) */
