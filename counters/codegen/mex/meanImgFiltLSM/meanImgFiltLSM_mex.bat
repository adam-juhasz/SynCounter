@echo off
set MATLAB=C:\PROGRA~1\MATLAB\R2018b
set MATLAB_ARCH=win64
set MATLAB_BIN="C:\Program Files\MATLAB\R2018b\bin"
set ENTRYPOINT=mexFunction
set OUTDIR=.\
set LIB_NAME=meanImgFiltLSM_mex
set MEX_NAME=meanImgFiltLSM_mex
set MEX_EXT=.mexw64
call setEnv.bat
echo # Make settings for meanImgFiltLSM > meanImgFiltLSM_mex.mki
echo COMPILER=%COMPILER%>> meanImgFiltLSM_mex.mki
echo COMPFLAGS=%COMPFLAGS%>> meanImgFiltLSM_mex.mki
echo OPTIMFLAGS=%OPTIMFLAGS%>> meanImgFiltLSM_mex.mki
echo DEBUGFLAGS=%DEBUGFLAGS%>> meanImgFiltLSM_mex.mki
echo LINKER=%LINKER%>> meanImgFiltLSM_mex.mki
echo LINKFLAGS=%LINKFLAGS%>> meanImgFiltLSM_mex.mki
echo LINKOPTIMFLAGS=%LINKOPTIMFLAGS%>> meanImgFiltLSM_mex.mki
echo LINKDEBUGFLAGS=%LINKDEBUGFLAGS%>> meanImgFiltLSM_mex.mki
echo MATLAB_ARCH=%MATLAB_ARCH%>> meanImgFiltLSM_mex.mki
echo BORLAND=%BORLAND%>> meanImgFiltLSM_mex.mki
echo CUDADEBUGFLAGS=>> meanImgFiltLSM_mex.mki
echo NVCC=nvcc >> meanImgFiltLSM_mex.mki
echo CUDA_FLAGS= -c -rdc=true -Xcompiler "/wd 4819" -Xcompiler "/MD" -Xcudafe "--diag_suppress=unsigned_compare_with_zero --diag_suppress=useless_type_qualifier_on_return_type" -D_GNU_SOURCE -DMATLAB_MEX_FILE -Wno-deprecated-declarations  >> meanImgFiltLSM_mex.mki
echo LD=nvcc >> meanImgFiltLSM_mex.mki
echo MAPLIBS=libemlrt.lib,libcovrt.lib,libut.lib,libmwmathutil.lib,/export:mexFunction,/export:emlrtMexFcnProperties >> meanImgFiltLSM_mex.mki
echo OMPFLAGS= >> meanImgFiltLSM_mex.mki
echo OMPLINKFLAGS= >> meanImgFiltLSM_mex.mki
echo EMC_COMPILER=msvcpp150>> meanImgFiltLSM_mex.mki
echo EMC_CONFIG=optim>> meanImgFiltLSM_mex.mki
"C:\Program Files\MATLAB\R2018b\bin\win64\gmake" -B -f meanImgFiltLSM_mex.mk
