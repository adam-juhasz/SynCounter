MATLAB_ROOT = C:\PROGRA~1\MATLAB\R2018b
MAKEFILE = meanImgFiltCZI_mex.mk

include meanImgFiltCZI_mex.mki


SRC_FILES =  \
	meanImgFiltCZI_data.cu \
	meanImgFiltCZI_initialize.cu \
	meanImgFiltCZI_terminate.cu \
	meanImgFiltCZI.cu \
	_coder_meanImgFiltCZI_info.cu \
	_coder_meanImgFiltCZI_api.cu \
	_coder_meanImgFiltCZI_mex.cu \
	MWCudaDimUtility.cu \
	cpp_mexapi_version.cpp

MEX_FILE_NAME_WO_EXT = meanImgFiltCZI_mex
MEX_FILE_NAME = $(MEX_FILE_NAME_WO_EXT).mexw64
TARGET = $(MEX_FILE_NAME)

SYS_LIBS = 


#
#====================================================================
# gmake makefile fragment for building MEX functions using MSVC
# Copyright 2007-2018 The MathWorks, Inc.
#====================================================================
#
SHELL = cmd
OBJEXT = obj
CC = $(COMPILER)
#LD = $(LINKER)
.SUFFIXES: .$(OBJEXT) .cu

OBJLISTC = $(SRC_FILES:.c=.$(OBJEXT))
OBJLISTCPP  = $(OBJLISTC:.cpp=.$(OBJEXT))
OBJLIST  = $(OBJLISTCPP:.cu=.$(OBJEXT))

TARGETMT = $(TARGET).manifest
MEX = $(TARGETMT)
STRICTFP = /fp:strict

target: $(MEX)

MATLAB_INCLUDES = -I "$(MATLAB_ROOT)\simulink\include"
MATLAB_INCLUDES+= -I "$(MATLAB_ROOT)\toolbox\shared\simtargets"
SYS_INCLUDE = $(MATLAB_INCLUDES)

# Additional includes

SYS_INCLUDE += -I "D:\Adam\codes\codegen\mex\meanImgFiltCZI"
SYS_INCLUDE += -I "D:\Adam\codes"
SYS_INCLUDE += -I ".\interface"
SYS_INCLUDE += -I "$(MATLAB_ROOT)\extern\include"
SYS_INCLUDE += -I "."

CUDA_LIBS = -L"$(CUDA_PATH)\lib\x64" cuda.lib cudart.lib cublas.lib cusolver.lib cufft.lib
SYS_LIBS += $(CUDA_LIBS) $(CLIBS)

COMMA=,
DIRECTIVES = $(MEX_FILE_NAME_WO_EXT)_mex.arf
COMP_FLAGS = $(COMPFLAGS) $(OMPFLAGS)
LINK_FLAGS = $(filter-out /export:mexFunction, $(LINKFLAGS))
LINK_FLAGSX = $(patsubst /LIBPATH:%,-L%, $(LINKFLAGS))
LINK_FLAGS = $(patsubst /%,-Xlinker /%, $(LINK_FLAGSX))
LINK_FLAGS += -Xnvlink -w  -Wno-deprecated-gpu-targets
LINK_FLAGS += -Xlinker /NODEFAULTLIB:libcmt.lib

LINKDEBUGFLAGS := $(patsubst /%,-Xlinker /%, $(LINKDEBUGFLAGS))

ifeq ($(EMC_CONFIG),optim)
  COMP_FLAGS += $(OPTIMFLAGS) $(STRICTFP)
  LINK_FLAGS += $(LINKOPTIMFLAGS)
else
  COMP_FLAGS += $(DEBUGFLAGS)
  LINK_FLAGS += $(LINKDEBUGFLAGS)
  CUDA_FLAGS += $(CUDADEBUGFLAGS)
endif
LINK_FLAGS += $(OMPLINKFLAGS)
LINK_FLAGS += -o $(TARGET)
LINK_FLAGS +=  -arch sm_35

CFLAGS = $(COMP_FLAGS)   $(USER_INCLUDE) $(SYS_INCLUDE)
CPPFLAGS = $(COMP_FLAGS)   $(USER_INCLUDE) $(SYS_INCLUDE)
NVCCFLAGS =  $(CUDA_FLAGS)   -arch sm_35 $(USER_INCLUDE) $(SYS_INCLUDE)

%.$(OBJEXT) : %.c
	$(NVCC) $(NVCCFLAGS) "$<"

%.$(OBJEXT) : %.cpp
	$(NVCC) $(NVCCFLAGS) "$<"

%.$(OBJEXT) : %.cu
	$(NVCC) $(NVCCFLAGS) "$<"

# Additional sources

%.$(OBJEXT) : /%.cu
	$(NVCC) $(NVCCFLAGS) "$<"
%.$(OBJEXT) : D:\Adam\codes/%.cu
	$(NVCC) $(NVCCFLAGS) "$<"
%.$(OBJEXT) : D:\Adam\codes\codegen\mex\meanImgFiltCZI/%.cu
	$(NVCC) $(NVCCFLAGS) "$<"
%.$(OBJEXT) : interface/%.cu
	$(NVCC) $(NVCCFLAGS) "$<"


%.$(OBJEXT) : /%.c
	$(NVCC) $(NVCCFLAGS) "$<"
%.$(OBJEXT) : D:\Adam\codes/%.c
	$(NVCC) $(NVCCFLAGS) "$<"
%.$(OBJEXT) : D:\Adam\codes\codegen\mex\meanImgFiltCZI/%.c
	$(NVCC) $(NVCCFLAGS) "$<"
%.$(OBJEXT) : interface/%.c
	$(NVCC) $(NVCCFLAGS) "$<"


%.$(OBJEXT) : /%.cpp
	$(CC) $(CPPFLAGS) "$<"
%.$(OBJEXT) : D:\Adam\codes/%.cpp
	$(CC) $(CPPFLAGS) "$<"
%.$(OBJEXT) : D:\Adam\codes\codegen\mex\meanImgFiltCZI/%.cpp
	$(CC) $(CPPFLAGS) "$<"
%.$(OBJEXT) : interface/%.cpp
	$(CC) $(CPPFLAGS) "$<"



$(TARGET): $(OBJLIST) $(MAKEFILE)
	$(LD) $(LINK_FLAGS) $(OBJLIST) $(USER_LIBS) $(SYS_LIBS) -Xlinker $(MAPLIBS)
	@cmd /C "echo Build completed using compiler $(EMC_COMPILER)"

$(TARGETMT): $(TARGET)
	mt -outputresource:"$(TARGET);2" -manifest "$(TARGET).manifest"

#====================================================================
