@echo off
set MATLAB=C:\PROGRA~1\MATLAB\R2018b
set MATLAB_ARCH=win64
set MATLAB_BIN="C:\Program Files\MATLAB\R2018b\bin"
set ENTRYPOINT=mexFunction
set OUTDIR=.\
set LIB_NAME=meanImgFiltCZI_mex
set MEX_NAME=meanImgFiltCZI_mex
set MEX_EXT=.mexw64
call setEnv.bat
echo # Make settings for meanImgFiltCZI > meanImgFiltCZI_mex.mki
echo COMPILER=%COMPILER%>> meanImgFiltCZI_mex.mki
echo COMPFLAGS=%COMPFLAGS%>> meanImgFiltCZI_mex.mki
echo OPTIMFLAGS=%OPTIMFLAGS%>> meanImgFiltCZI_mex.mki
echo DEBUGFLAGS=%DEBUGFLAGS%>> meanImgFiltCZI_mex.mki
echo LINKER=%LINKER%>> meanImgFiltCZI_mex.mki
echo LINKFLAGS=%LINKFLAGS%>> meanImgFiltCZI_mex.mki
echo LINKOPTIMFLAGS=%LINKOPTIMFLAGS%>> meanImgFiltCZI_mex.mki
echo LINKDEBUGFLAGS=%LINKDEBUGFLAGS%>> meanImgFiltCZI_mex.mki
echo MATLAB_ARCH=%MATLAB_ARCH%>> meanImgFiltCZI_mex.mki
echo BORLAND=%BORLAND%>> meanImgFiltCZI_mex.mki
echo CUDADEBUGFLAGS=>> meanImgFiltCZI_mex.mki
echo NVCC=nvcc >> meanImgFiltCZI_mex.mki
echo CUDA_FLAGS= -c -rdc=true -Xcompiler "/wd 4819" -Xcompiler "/MD" -Xcudafe "--diag_suppress=unsigned_compare_with_zero --diag_suppress=useless_type_qualifier_on_return_type" -D_GNU_SOURCE -DMATLAB_MEX_FILE -Wno-deprecated-declarations  >> meanImgFiltCZI_mex.mki
echo LD=nvcc >> meanImgFiltCZI_mex.mki
echo MAPLIBS=libemlrt.lib,libcovrt.lib,libut.lib,libmwmathutil.lib,/export:mexFunction,/export:emlrtMexFcnProperties >> meanImgFiltCZI_mex.mki
echo OMPFLAGS= >> meanImgFiltCZI_mex.mki
echo OMPLINKFLAGS= >> meanImgFiltCZI_mex.mki
echo EMC_COMPILER=msvcpp150>> meanImgFiltCZI_mex.mki
echo EMC_CONFIG=optim>> meanImgFiltCZI_mex.mki
"C:\Program Files\MATLAB\R2018b\bin\win64\gmake" -B -f meanImgFiltCZI_mex.mk
