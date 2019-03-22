/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * _coder_meanImgFiltCZI_mex.cu
 *
 * Code generation for function '_coder_meanImgFiltCZI_mex'
 *
 */

/* Include files */
#include "meanImgFiltCZI.h"
#include "_coder_meanImgFiltCZI_mex.h"
#include "meanImgFiltCZI_terminate.h"
#include "_coder_meanImgFiltCZI_api.h"
#include "meanImgFiltCZI_initialize.h"
#include "meanImgFiltCZI_data.h"

/* Function Declarations */
static void meanImgFiltCZI_mexFunction(int32_T nlhs, mxArray *plhs[1], int32_T
  nrhs, const mxArray *prhs[1]);

/* Function Definitions */
static void meanImgFiltCZI_mexFunction(int32_T nlhs, mxArray *plhs[1], int32_T
  nrhs, const mxArray *prhs[1])
{
  const mxArray *outputs[1];

  /* Check for proper number of arguments. */
  if (nrhs != 1) {
    emlrtErrMsgIdAndTxt(emlrtRootTLSGlobal, "EMLRT:runTime:WrongNumberOfInputs",
                        5, 12, 1, 4, 14, "meanImgFiltCZI");
  }

  if (nlhs > 1) {
    emlrtErrMsgIdAndTxt(emlrtRootTLSGlobal,
                        "EMLRT:runTime:TooManyOutputArguments", 3, 4, 14,
                        "meanImgFiltCZI");
  }

  /* Call the function. */
  meanImgFiltCZI_api(prhs, nlhs, outputs);

  /* Copy over outputs to the caller. */
  emlrtReturnArrays(1, plhs, outputs);
}

void mexFunction(int32_T nlhs, mxArray *plhs[], int32_T nrhs, const mxArray
                 *prhs[])
{
  mexAtExit(meanImgFiltCZI_atexit);

  /* Module initialization. */
  meanImgFiltCZI_initialize();

  /* Dispatch the entry-point. */
  meanImgFiltCZI_mexFunction(nlhs, plhs, nrhs, prhs);

  /* Module termination. */
  meanImgFiltCZI_terminate();
}

emlrtCTX mexFunctionCreateRootTLS()
{
  emlrtCreateRootTLS(&emlrtRootTLSGlobal, &emlrtContextGlobal, NULL, 1);
  return emlrtRootTLSGlobal;
}

/* End of code generation (_coder_meanImgFiltCZI_mex.cu) */
