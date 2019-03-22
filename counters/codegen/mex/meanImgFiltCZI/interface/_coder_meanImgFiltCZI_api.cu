/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * _coder_meanImgFiltCZI_api.cu
 *
 * Code generation for function '_coder_meanImgFiltCZI_api'
 *
 */

/* Include files */
#include "rt_nonfinite.h"
#include "meanImgFiltCZI.h"
#include "_coder_meanImgFiltCZI_api.h"
#include "meanImgFiltCZI_data.h"

/* Function Declarations */
static real_T (*b_emlrt_marshallIn(const mxArray *u, const emlrtMsgIdentifier
  *parentId))[1048576];
static real_T (*c_emlrt_marshallIn(const mxArray *src, const emlrtMsgIdentifier *
  msgId))[1048576];
static real_T (*emlrt_marshallIn(const mxArray *A, const char_T *identifier))
  [1048576];
static const mxArray *emlrt_marshallOut(const real_T u[1048576]);

/* Function Definitions */
static real_T (*b_emlrt_marshallIn(const mxArray *u, const emlrtMsgIdentifier
  *parentId))[1048576]
{
  real_T (*y)[1048576];
  y = c_emlrt_marshallIn(emlrtAlias(u), parentId);
  emlrtDestroyArray(&u);
  return y;
}
  static real_T (*c_emlrt_marshallIn(const mxArray *src, const
  emlrtMsgIdentifier *msgId))[1048576]
{
  real_T (*ret)[1048576];
  static const int32_T dims[2] = { 1024, 1024 };

  emlrtCheckBuiltInR2012b(emlrtRootTLSGlobal, (const emlrtMsgIdentifier *)msgId,
    src, "double", false, 2U, *(int32_T (*)[2])&dims[0]);
  ret = (real_T (*)[1048576])emlrtMxGetData(src);
  emlrtDestroyArray(&src);
  return ret;
}

static real_T (*emlrt_marshallIn(const mxArray *A, const char_T *identifier))
  [1048576]
{
  real_T (*y)[1048576];
  emlrtMsgIdentifier thisId;
  thisId.fIdentifier = const_cast<const char *>(identifier);
  thisId.fParent = NULL;
  thisId.bParentIsCell = false;
  y = b_emlrt_marshallIn(emlrtAlias(A), &thisId);
  emlrtDestroyArray(&A);
  return y;
}
  static const mxArray *emlrt_marshallOut(const real_T u[1048576])
{
  const mxArray *y;
  const mxArray *m0;
  static const int32_T iv0[2] = { 0, 0 };

  static const int32_T iv1[2] = { 1024, 1024 };

  y = NULL;
  m0 = emlrtCreateNumericArray(2, iv0, mxDOUBLE_CLASS, mxREAL);
  emlrtMxSetData((mxArray *)m0, (void *)&u[0]);
  emlrtSetDimensions((mxArray *)m0, *(int32_T (*)[2])&iv1[0], 2);
  emlrtAssign(&y, m0);
  return y;
}

void meanImgFiltCZI_api(const mxArray * const prhs[1], int32_T, const mxArray
  *plhs[1])
{
  real_T (*B)[1048576];
  real_T (*A)[1048576];
  B = (real_T (*)[1048576])mxMalloc(sizeof(real_T [1048576]));

  /* Marshall function inputs */
  A = emlrt_marshallIn(emlrtAlias(prhs[0]), "A");

  /* Invoke the target function */
  meanImgFiltCZI(*A, *B);

  /* Marshall function outputs */
  plhs[0] = emlrt_marshallOut(*B);
}

/* End of code generation (_coder_meanImgFiltCZI_api.cu) */
