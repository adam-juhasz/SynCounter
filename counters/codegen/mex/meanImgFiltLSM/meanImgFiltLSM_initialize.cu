/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * meanImgFiltLSM_initialize.cu
 *
 * Code generation for function 'meanImgFiltLSM_initialize'
 *
 */

/* Include files */
#include "rt_nonfinite.h"
#include "meanImgFiltLSM.h"
#include "meanImgFiltLSM_initialize.h"
#include "_coder_meanImgFiltLSM_mex.h"
#include "meanImgFiltLSM_data.h"

/* Function Definitions */
void meanImgFiltLSM_initialize()
{
  mexFunctionCreateRootTLS();
  emlrtClearAllocCountR2012b(emlrtRootTLSGlobal, false, 0U, 0);
  emlrtEnterRtStackR2012b(emlrtRootTLSGlobal);
  emlrtLicenseCheckR2012b(emlrtRootTLSGlobal, "Distrib_Computing_Toolbox", 2);
  emlrtFirstTimeR2012b(emlrtRootTLSGlobal);
}

/* End of code generation (meanImgFiltLSM_initialize.cu) */
