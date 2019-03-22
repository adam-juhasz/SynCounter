/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * _coder_meanImgFiltLSM_mex.cu
 *
 * Code generation for function '_coder_meanImgFiltLSM_mex'
 *
 */

/* Include files */
#include "meanImgFiltLSM.h"
#include "_coder_meanImgFiltLSM_mex.h"
#include "meanImgFiltLSM_terminate.h"
#include "_coder_meanImgFiltLSM_api.h"
#include "meanImgFiltLSM_initialize.h"
#include "meanImgFiltLSM_data.h"

/* Function Declarations */
static void meanImgFiltLSM_mexFunction(int32_T nlhs, mxArray *plhs[1], int32_T
  nrhs, const mxArray *prhs[1]);

/* Function Definitions */
static void meanImgFiltLSM_mexFunction(int32_T nlhs, mxArray *plhs[1], int32_T
  nrhs, const mxArray *prhs[1])
{
  const mxArray *outputs[1];

  /* Check for proper number of arguments. */
  if (nrhs != 1) {
    emlrtErrMsgIdAndTxt(emlrtRootTLSGlobal, "EMLRT:runTime:WrongNumberOfInputs",
                        5, 12, 1, 4, 14, "meanImgFiltLSM");
  }

  if (nlhs > 1) {
    emlrtErrMsgIdAndTxt(emlrtRootTLSGlobal,
                        "EMLRT:runTime:TooManyOutputArguments", 3, 4, 14,
                        "meanImgFiltLSM");
  }

  /* Call the function. */
  meanImgFiltLSM_api(prhs, nlhs, outputs);

  /* Copy over outputs to the caller. */
  emlrtReturnArrays(1, plhs, outputs);
}

void mexFunction(int32_T nlhs, mxArray *plhs[], int32_T nrhs, const mxArray
                 *prhs[])
{
  mexAtExit(meanImgFiltLSM_atexit);

  /* Module initialization. */
  meanImgFiltLSM_initialize();

  /* Dispatch the entry-point. */
  meanImgFiltLSM_mexFunction(nlhs, plhs, nrhs, prhs);

  /* Module termination. */
  meanImgFiltLSM_terminate();
}

emlrtCTX mexFunctionCreateRootTLS()
{
  emlrtCreateRootTLS(&emlrtRootTLSGlobal, &emlrtContextGlobal, NULL, 1);
  return emlrtRootTLSGlobal;
}

/* End of code generation (_coder_meanImgFiltLSM_mex.cu) */
