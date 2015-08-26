/*
 * MATLAB Compiler: 5.2 (R2014b)
 * Date: Mon Aug 24 21:40:46 2015
 * Arguments: "-B" "macro_default" "-v" "-m" "-W" "main" "-T" "link:exe"
 * "starsun.m" "-I" "data_folder/" "-I" "/u/sleblan2/SEAC4RS/starinfo/" "-I"
 * "/u/sleblan2/SEAC4RS/starinfo/v2/" "-l"
 * "/u/sleblan2/SEAC4RS/starinfo/starinfo20120718.m"
 * "/u/sleblan2/SEAC4RS/starinfo/starinfo20130802.m"
 * "/u/sleblan2/SEAC4RS/starinfo/starinfo20130803.m"
 * "/u/sleblan2/SEAC4RS/starinfo/starinfo20130805.m"
 * "/u/sleblan2/SEAC4RS/starinfo/starinfo20130806.m"
 * "/u/sleblan2/SEAC4RS/starinfo/starinfo20130807.m"
 * "/u/sleblan2/SEAC4RS/starinfo/starinfo20130808.m"
 * "/u/sleblan2/SEAC4RS/starinfo/starinfo20130812.m"
 * "/u/sleblan2/SEAC4RS/starinfo/starinfo20130813.m"
 * "/u/sleblan2/SEAC4RS/starinfo/starinfo20130814.m"
 * "/u/sleblan2/SEAC4RS/starinfo/starinfo20130815.m"
 * "/u/sleblan2/SEAC4RS/starinfo/starinfo20130816.m"
 * "/u/sleblan2/SEAC4RS/starinfo/starinfo20130818.m"
 * "/u/sleblan2/SEAC4RS/starinfo/starinfo20130819.m"
 * "/u/sleblan2/SEAC4RS/starinfo/starinfo20130821.m"
 * "/u/sleblan2/SEAC4RS/starinfo/starinfo20130823.m"
 * "/u/sleblan2/SEAC4RS/starinfo/starinfo20130826.m"
 * "/u/sleblan2/SEAC4RS/starinfo/starinfo20130827.m"
 * "/u/sleblan2/SEAC4RS/starinfo/starinfo20130828.m"
 * "/u/sleblan2/SEAC4RS/starinfo/starinfo20130830.m"
 * "/u/sleblan2/SEAC4RS/starinfo/starinfo20130831.m"
 * "/u/sleblan2/SEAC4RS/starinfo/starinfo20130902.m"
 * "/u/sleblan2/SEAC4RS/starinfo/starinfo20130904.m"
 * "/u/sleblan2/SEAC4RS/starinfo/starinfo20130906.m"
 * "/u/sleblan2/SEAC4RS/starinfo/starinfo20130907.m"
 * "/u/sleblan2/SEAC4RS/starinfo/starinfo20130908.m"
 * "/u/sleblan2/SEAC4RS/starinfo/starinfo20130909.m"
 * "/u/sleblan2/SEAC4RS/starinfo/starinfo20130911.m"
 * "/u/sleblan2/SEAC4RS/starinfo/starinfo20130913.m"
 * "/u/sleblan2/SEAC4RS/starinfo/starinfo20130916.m"
 * "/u/sleblan2/SEAC4RS/starinfo/starinfo20130917.m"
 * "/u/sleblan2/SEAC4RS/starinfo/starinfo20130918.m"
 * "/u/sleblan2/SEAC4RS/starinfo/starinfo20130921.m"
 * "/u/sleblan2/SEAC4RS/starinfo/starinfo20130923.m"
 * "/u/sleblan2/SEAC4RS/starinfo/starinfo20130930.m"
 * "/u/sleblan2/SEAC4RS/starinfo/starinfo20140907.m" 
 */

#include <stdio.h>
#define EXPORTING_starsun 1
#include "starsun.h"

static HMCRINSTANCE _mcr_inst = NULL;


#ifdef __cplusplus
extern "C" {
#endif

static int mclDefaultPrintHandler(const char *s)
{
  return mclWrite(1 /* stdout */, s, sizeof(char)*strlen(s));
}

#ifdef __cplusplus
} /* End extern "C" block */
#endif

#ifdef __cplusplus
extern "C" {
#endif

static int mclDefaultErrorHandler(const char *s)
{
  int written = 0;
  size_t len = 0;
  len = strlen(s);
  written = mclWrite(2 /* stderr */, s, sizeof(char)*len);
  if (len > 0 && s[ len-1 ] != '\n')
    written += mclWrite(2 /* stderr */, "\n", sizeof(char));
  return written;
}

#ifdef __cplusplus
} /* End extern "C" block */
#endif

/* This symbol is defined in shared libraries. Define it here
 * (to nothing) in case this isn't a shared library. 
 */
#ifndef LIB_starsun_C_API
#define LIB_starsun_C_API /* No special import/export declaration */
#endif

LIB_starsun_C_API 
bool MW_CALL_CONV starsunInitializeWithHandlers(
    mclOutputHandlerFcn error_handler,
    mclOutputHandlerFcn print_handler)
{
    int bResult = 0;
  if (_mcr_inst != NULL)
    return true;
  if (!mclmcrInitialize())
    return false;
    {
        mclCtfStream ctfStream = 
            mclGetEmbeddedCtfStream((void *)(starsunInitializeWithHandlers));
        if (ctfStream) {
            bResult = mclInitializeComponentInstanceEmbedded(   &_mcr_inst,
                                                                error_handler, 
                                                                print_handler,
                                                                ctfStream);
            mclDestroyStream(ctfStream);
        } else {
            bResult = 0;
        }
    }  
    if (!bResult)
    return false;
  return true;
}

LIB_starsun_C_API 
bool MW_CALL_CONV starsunInitialize(void)
{
  return starsunInitializeWithHandlers(mclDefaultErrorHandler, mclDefaultPrintHandler);
}

LIB_starsun_C_API 
void MW_CALL_CONV starsunTerminate(void)
{
  if (_mcr_inst != NULL)
    mclTerminateInstance(&_mcr_inst);
}

LIB_starsun_C_API 
void MW_CALL_CONV starsunPrintStackTrace(void) 
{
  char** stackTrace;
  int stackDepth = mclGetStackTrace(&stackTrace);
  int i;
  for(i=0; i<stackDepth; i++)
  {
    mclWrite(2 /* stderr */, stackTrace[i], sizeof(char)*strlen(stackTrace[i]));
    mclWrite(2 /* stderr */, "\n", sizeof(char)*strlen("\n"));
  }
  mclFreeStackTrace(&stackTrace, stackDepth);
}


LIB_starsun_C_API 
bool MW_CALL_CONV mlxStarsun(int nlhs, mxArray *plhs[], int nrhs, mxArray *prhs[])
{
  return mclFeval(_mcr_inst, "starsun", nlhs, plhs, nrhs, prhs);
}

LIB_starsun_C_API 
bool MW_CALL_CONV mlxStarinfo20120718(int nlhs, mxArray *plhs[], int nrhs, mxArray 
                                      *prhs[])
{
  return mclFeval(_mcr_inst, "starinfo20120718", nlhs, plhs, nrhs, prhs);
}

LIB_starsun_C_API 
bool MW_CALL_CONV mlxStarinfo20130802(int nlhs, mxArray *plhs[], int nrhs, mxArray 
                                      *prhs[])
{
  return mclFeval(_mcr_inst, "starinfo20130802", nlhs, plhs, nrhs, prhs);
}

LIB_starsun_C_API 
bool MW_CALL_CONV mlxStarinfo20130803(int nlhs, mxArray *plhs[], int nrhs, mxArray 
                                      *prhs[])
{
  return mclFeval(_mcr_inst, "starinfo20130803", nlhs, plhs, nrhs, prhs);
}

LIB_starsun_C_API 
bool MW_CALL_CONV mlxStarinfo20130805(int nlhs, mxArray *plhs[], int nrhs, mxArray 
                                      *prhs[])
{
  return mclFeval(_mcr_inst, "starinfo20130805", nlhs, plhs, nrhs, prhs);
}

LIB_starsun_C_API 
bool MW_CALL_CONV mlxStarinfo20130806(int nlhs, mxArray *plhs[], int nrhs, mxArray 
                                      *prhs[])
{
  return mclFeval(_mcr_inst, "starinfo20130806", nlhs, plhs, nrhs, prhs);
}

LIB_starsun_C_API 
bool MW_CALL_CONV mlxStarinfo20130807(int nlhs, mxArray *plhs[], int nrhs, mxArray 
                                      *prhs[])
{
  return mclFeval(_mcr_inst, "starinfo20130807", nlhs, plhs, nrhs, prhs);
}

LIB_starsun_C_API 
bool MW_CALL_CONV mlxStarinfo20130808(int nlhs, mxArray *plhs[], int nrhs, mxArray 
                                      *prhs[])
{
  return mclFeval(_mcr_inst, "starinfo20130808", nlhs, plhs, nrhs, prhs);
}

LIB_starsun_C_API 
bool MW_CALL_CONV mlxStarinfo20130812(int nlhs, mxArray *plhs[], int nrhs, mxArray 
                                      *prhs[])
{
  return mclFeval(_mcr_inst, "starinfo20130812", nlhs, plhs, nrhs, prhs);
}

LIB_starsun_C_API 
bool MW_CALL_CONV mlxStarinfo20130813(int nlhs, mxArray *plhs[], int nrhs, mxArray 
                                      *prhs[])
{
  return mclFeval(_mcr_inst, "starinfo20130813", nlhs, plhs, nrhs, prhs);
}

LIB_starsun_C_API 
bool MW_CALL_CONV mlxStarinfo20130814(int nlhs, mxArray *plhs[], int nrhs, mxArray 
                                      *prhs[])
{
  return mclFeval(_mcr_inst, "starinfo20130814", nlhs, plhs, nrhs, prhs);
}

LIB_starsun_C_API 
bool MW_CALL_CONV mlxStarinfo20130815(int nlhs, mxArray *plhs[], int nrhs, mxArray 
                                      *prhs[])
{
  return mclFeval(_mcr_inst, "starinfo20130815", nlhs, plhs, nrhs, prhs);
}

LIB_starsun_C_API 
bool MW_CALL_CONV mlxStarinfo20130816(int nlhs, mxArray *plhs[], int nrhs, mxArray 
                                      *prhs[])
{
  return mclFeval(_mcr_inst, "starinfo20130816", nlhs, plhs, nrhs, prhs);
}

LIB_starsun_C_API 
bool MW_CALL_CONV mlxStarinfo20130818(int nlhs, mxArray *plhs[], int nrhs, mxArray 
                                      *prhs[])
{
  return mclFeval(_mcr_inst, "starinfo20130818", nlhs, plhs, nrhs, prhs);
}

LIB_starsun_C_API 
bool MW_CALL_CONV mlxStarinfo20130819(int nlhs, mxArray *plhs[], int nrhs, mxArray 
                                      *prhs[])
{
  return mclFeval(_mcr_inst, "starinfo20130819", nlhs, plhs, nrhs, prhs);
}

LIB_starsun_C_API 
bool MW_CALL_CONV mlxStarinfo20130821(int nlhs, mxArray *plhs[], int nrhs, mxArray 
                                      *prhs[])
{
  return mclFeval(_mcr_inst, "starinfo20130821", nlhs, plhs, nrhs, prhs);
}

LIB_starsun_C_API 
bool MW_CALL_CONV mlxStarinfo20130823(int nlhs, mxArray *plhs[], int nrhs, mxArray 
                                      *prhs[])
{
  return mclFeval(_mcr_inst, "starinfo20130823", nlhs, plhs, nrhs, prhs);
}

LIB_starsun_C_API 
bool MW_CALL_CONV mlxStarinfo20130826(int nlhs, mxArray *plhs[], int nrhs, mxArray 
                                      *prhs[])
{
  return mclFeval(_mcr_inst, "starinfo20130826", nlhs, plhs, nrhs, prhs);
}

LIB_starsun_C_API 
bool MW_CALL_CONV mlxStarinfo20130827(int nlhs, mxArray *plhs[], int nrhs, mxArray 
                                      *prhs[])
{
  return mclFeval(_mcr_inst, "starinfo20130827", nlhs, plhs, nrhs, prhs);
}

LIB_starsun_C_API 
bool MW_CALL_CONV mlxStarinfo20130828(int nlhs, mxArray *plhs[], int nrhs, mxArray 
                                      *prhs[])
{
  return mclFeval(_mcr_inst, "starinfo20130828", nlhs, plhs, nrhs, prhs);
}

LIB_starsun_C_API 
bool MW_CALL_CONV mlxStarinfo20130830(int nlhs, mxArray *plhs[], int nrhs, mxArray 
                                      *prhs[])
{
  return mclFeval(_mcr_inst, "starinfo20130830", nlhs, plhs, nrhs, prhs);
}

LIB_starsun_C_API 
bool MW_CALL_CONV mlxStarinfo20130831(int nlhs, mxArray *plhs[], int nrhs, mxArray 
                                      *prhs[])
{
  return mclFeval(_mcr_inst, "starinfo20130831", nlhs, plhs, nrhs, prhs);
}

LIB_starsun_C_API 
bool MW_CALL_CONV mlxStarinfo20130902(int nlhs, mxArray *plhs[], int nrhs, mxArray 
                                      *prhs[])
{
  return mclFeval(_mcr_inst, "starinfo20130902", nlhs, plhs, nrhs, prhs);
}

LIB_starsun_C_API 
bool MW_CALL_CONV mlxStarinfo20130904(int nlhs, mxArray *plhs[], int nrhs, mxArray 
                                      *prhs[])
{
  return mclFeval(_mcr_inst, "starinfo20130904", nlhs, plhs, nrhs, prhs);
}

LIB_starsun_C_API 
bool MW_CALL_CONV mlxStarinfo20130906(int nlhs, mxArray *plhs[], int nrhs, mxArray 
                                      *prhs[])
{
  return mclFeval(_mcr_inst, "starinfo20130906", nlhs, plhs, nrhs, prhs);
}

LIB_starsun_C_API 
bool MW_CALL_CONV mlxStarinfo20130907(int nlhs, mxArray *plhs[], int nrhs, mxArray 
                                      *prhs[])
{
  return mclFeval(_mcr_inst, "starinfo20130907", nlhs, plhs, nrhs, prhs);
}

LIB_starsun_C_API 
bool MW_CALL_CONV mlxStarinfo20130908(int nlhs, mxArray *plhs[], int nrhs, mxArray 
                                      *prhs[])
{
  return mclFeval(_mcr_inst, "starinfo20130908", nlhs, plhs, nrhs, prhs);
}

LIB_starsun_C_API 
bool MW_CALL_CONV mlxStarinfo20130909(int nlhs, mxArray *plhs[], int nrhs, mxArray 
                                      *prhs[])
{
  return mclFeval(_mcr_inst, "starinfo20130909", nlhs, plhs, nrhs, prhs);
}

LIB_starsun_C_API 
bool MW_CALL_CONV mlxStarinfo20130911(int nlhs, mxArray *plhs[], int nrhs, mxArray 
                                      *prhs[])
{
  return mclFeval(_mcr_inst, "starinfo20130911", nlhs, plhs, nrhs, prhs);
}

LIB_starsun_C_API 
bool MW_CALL_CONV mlxStarinfo20130913(int nlhs, mxArray *plhs[], int nrhs, mxArray 
                                      *prhs[])
{
  return mclFeval(_mcr_inst, "starinfo20130913", nlhs, plhs, nrhs, prhs);
}

LIB_starsun_C_API 
bool MW_CALL_CONV mlxStarinfo20130916(int nlhs, mxArray *plhs[], int nrhs, mxArray 
                                      *prhs[])
{
  return mclFeval(_mcr_inst, "starinfo20130916", nlhs, plhs, nrhs, prhs);
}

LIB_starsun_C_API 
bool MW_CALL_CONV mlxStarinfo20130917(int nlhs, mxArray *plhs[], int nrhs, mxArray 
                                      *prhs[])
{
  return mclFeval(_mcr_inst, "starinfo20130917", nlhs, plhs, nrhs, prhs);
}

LIB_starsun_C_API 
bool MW_CALL_CONV mlxStarinfo20130918(int nlhs, mxArray *plhs[], int nrhs, mxArray 
                                      *prhs[])
{
  return mclFeval(_mcr_inst, "starinfo20130918", nlhs, plhs, nrhs, prhs);
}

LIB_starsun_C_API 
bool MW_CALL_CONV mlxStarinfo20130921(int nlhs, mxArray *plhs[], int nrhs, mxArray 
                                      *prhs[])
{
  return mclFeval(_mcr_inst, "starinfo20130921", nlhs, plhs, nrhs, prhs);
}

LIB_starsun_C_API 
bool MW_CALL_CONV mlxStarinfo20130923(int nlhs, mxArray *plhs[], int nrhs, mxArray 
                                      *prhs[])
{
  return mclFeval(_mcr_inst, "starinfo20130923", nlhs, plhs, nrhs, prhs);
}

LIB_starsun_C_API 
bool MW_CALL_CONV mlxStarinfo20130930(int nlhs, mxArray *plhs[], int nrhs, mxArray 
                                      *prhs[])
{
  return mclFeval(_mcr_inst, "starinfo20130930", nlhs, plhs, nrhs, prhs);
}

LIB_starsun_C_API 
bool MW_CALL_CONV mlxStarinfo20140907(int nlhs, mxArray *plhs[], int nrhs, mxArray 
                                      *prhs[])
{
  return mclFeval(_mcr_inst, "starinfo20140907", nlhs, plhs, nrhs, prhs);
}

LIB_starsun_C_API 
bool MW_CALL_CONV mlfStarsun(int nargout, mxArray** savematfile, mxArray** contents, 
                             mxArray* varargin)
{
  return mclMlfFeval(_mcr_inst, "starsun", nargout, 2, -1, savematfile, contents, varargin);
}

LIB_starsun_C_API 
bool MW_CALL_CONV mlfStarinfo20120718()
{
  return mclMlfFeval(_mcr_inst, "starinfo20120718", 0, 0, 0);
}

LIB_starsun_C_API 
bool MW_CALL_CONV mlfStarinfo20130802()
{
  return mclMlfFeval(_mcr_inst, "starinfo20130802", 0, 0, 0);
}

LIB_starsun_C_API 
bool MW_CALL_CONV mlfStarinfo20130803()
{
  return mclMlfFeval(_mcr_inst, "starinfo20130803", 0, 0, 0);
}

LIB_starsun_C_API 
bool MW_CALL_CONV mlfStarinfo20130805()
{
  return mclMlfFeval(_mcr_inst, "starinfo20130805", 0, 0, 0);
}

LIB_starsun_C_API 
bool MW_CALL_CONV mlfStarinfo20130806()
{
  return mclMlfFeval(_mcr_inst, "starinfo20130806", 0, 0, 0);
}

LIB_starsun_C_API 
bool MW_CALL_CONV mlfStarinfo20130807()
{
  return mclMlfFeval(_mcr_inst, "starinfo20130807", 0, 0, 0);
}

LIB_starsun_C_API 
bool MW_CALL_CONV mlfStarinfo20130808()
{
  return mclMlfFeval(_mcr_inst, "starinfo20130808", 0, 0, 0);
}

LIB_starsun_C_API 
bool MW_CALL_CONV mlfStarinfo20130812()
{
  return mclMlfFeval(_mcr_inst, "starinfo20130812", 0, 0, 0);
}

LIB_starsun_C_API 
bool MW_CALL_CONV mlfStarinfo20130813()
{
  return mclMlfFeval(_mcr_inst, "starinfo20130813", 0, 0, 0);
}

LIB_starsun_C_API 
bool MW_CALL_CONV mlfStarinfo20130814()
{
  return mclMlfFeval(_mcr_inst, "starinfo20130814", 0, 0, 0);
}

LIB_starsun_C_API 
bool MW_CALL_CONV mlfStarinfo20130815()
{
  return mclMlfFeval(_mcr_inst, "starinfo20130815", 0, 0, 0);
}

LIB_starsun_C_API 
bool MW_CALL_CONV mlfStarinfo20130816()
{
  return mclMlfFeval(_mcr_inst, "starinfo20130816", 0, 0, 0);
}

LIB_starsun_C_API 
bool MW_CALL_CONV mlfStarinfo20130818()
{
  return mclMlfFeval(_mcr_inst, "starinfo20130818", 0, 0, 0);
}

LIB_starsun_C_API 
bool MW_CALL_CONV mlfStarinfo20130819()
{
  return mclMlfFeval(_mcr_inst, "starinfo20130819", 0, 0, 0);
}

LIB_starsun_C_API 
bool MW_CALL_CONV mlfStarinfo20130821()
{
  return mclMlfFeval(_mcr_inst, "starinfo20130821", 0, 0, 0);
}

LIB_starsun_C_API 
bool MW_CALL_CONV mlfStarinfo20130823()
{
  return mclMlfFeval(_mcr_inst, "starinfo20130823", 0, 0, 0);
}

LIB_starsun_C_API 
bool MW_CALL_CONV mlfStarinfo20130826()
{
  return mclMlfFeval(_mcr_inst, "starinfo20130826", 0, 0, 0);
}

LIB_starsun_C_API 
bool MW_CALL_CONV mlfStarinfo20130827()
{
  return mclMlfFeval(_mcr_inst, "starinfo20130827", 0, 0, 0);
}

LIB_starsun_C_API 
bool MW_CALL_CONV mlfStarinfo20130828()
{
  return mclMlfFeval(_mcr_inst, "starinfo20130828", 0, 0, 0);
}

LIB_starsun_C_API 
bool MW_CALL_CONV mlfStarinfo20130830()
{
  return mclMlfFeval(_mcr_inst, "starinfo20130830", 0, 0, 0);
}

LIB_starsun_C_API 
bool MW_CALL_CONV mlfStarinfo20130831()
{
  return mclMlfFeval(_mcr_inst, "starinfo20130831", 0, 0, 0);
}

LIB_starsun_C_API 
bool MW_CALL_CONV mlfStarinfo20130902()
{
  return mclMlfFeval(_mcr_inst, "starinfo20130902", 0, 0, 0);
}

LIB_starsun_C_API 
bool MW_CALL_CONV mlfStarinfo20130904()
{
  return mclMlfFeval(_mcr_inst, "starinfo20130904", 0, 0, 0);
}

LIB_starsun_C_API 
bool MW_CALL_CONV mlfStarinfo20130906()
{
  return mclMlfFeval(_mcr_inst, "starinfo20130906", 0, 0, 0);
}

LIB_starsun_C_API 
bool MW_CALL_CONV mlfStarinfo20130907()
{
  return mclMlfFeval(_mcr_inst, "starinfo20130907", 0, 0, 0);
}

LIB_starsun_C_API 
bool MW_CALL_CONV mlfStarinfo20130908()
{
  return mclMlfFeval(_mcr_inst, "starinfo20130908", 0, 0, 0);
}

LIB_starsun_C_API 
bool MW_CALL_CONV mlfStarinfo20130909()
{
  return mclMlfFeval(_mcr_inst, "starinfo20130909", 0, 0, 0);
}

LIB_starsun_C_API 
bool MW_CALL_CONV mlfStarinfo20130911()
{
  return mclMlfFeval(_mcr_inst, "starinfo20130911", 0, 0, 0);
}

LIB_starsun_C_API 
bool MW_CALL_CONV mlfStarinfo20130913()
{
  return mclMlfFeval(_mcr_inst, "starinfo20130913", 0, 0, 0);
}

LIB_starsun_C_API 
bool MW_CALL_CONV mlfStarinfo20130916()
{
  return mclMlfFeval(_mcr_inst, "starinfo20130916", 0, 0, 0);
}

LIB_starsun_C_API 
bool MW_CALL_CONV mlfStarinfo20130917()
{
  return mclMlfFeval(_mcr_inst, "starinfo20130917", 0, 0, 0);
}

LIB_starsun_C_API 
bool MW_CALL_CONV mlfStarinfo20130918()
{
  return mclMlfFeval(_mcr_inst, "starinfo20130918", 0, 0, 0);
}

LIB_starsun_C_API 
bool MW_CALL_CONV mlfStarinfo20130921()
{
  return mclMlfFeval(_mcr_inst, "starinfo20130921", 0, 0, 0);
}

LIB_starsun_C_API 
bool MW_CALL_CONV mlfStarinfo20130923()
{
  return mclMlfFeval(_mcr_inst, "starinfo20130923", 0, 0, 0);
}

LIB_starsun_C_API 
bool MW_CALL_CONV mlfStarinfo20130930()
{
  return mclMlfFeval(_mcr_inst, "starinfo20130930", 0, 0, 0);
}

LIB_starsun_C_API 
bool MW_CALL_CONV mlfStarinfo20140907()
{
  return mclMlfFeval(_mcr_inst, "starinfo20140907", 0, 0, 0);
}

