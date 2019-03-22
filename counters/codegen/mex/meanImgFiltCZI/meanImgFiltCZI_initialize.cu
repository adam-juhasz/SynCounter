/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * meanImgFiltCZI_initialize.cu
 *
 * Code generation for function 'meanImgFiltCZI_initialize'
 *
 */

/* Include files */
#include "rt_nonfinite.h"
#include "meanImgFiltCZI.h"
#include "meanImgFiltCZI_initialize.h"
#include "_coder_meanImgFiltCZI_mex.h"
#include "meanImgFiltCZI_data.h"

/* Function Definitions */
void meanImgFiltCZI_initialize()
{
  mexFunctionCreateRootTLS();
  emlrtClearAllocCountR2012b(emlrtRootTLSGlobal, false, 0U, 0);
  emlrtEnterRtStackR2012b(emlrtRootTLSGlobal);
  emlrtLicenseCheckR2012b(emlrtRootTLSGlobal, "Distrib_Computing_Toolbox", 2);
  emlrtFirstTimeR2012b(emlrtRootTLSGlobal);
}

/* End of code generation (meanImgFiltCZI_initialize.cu) */
