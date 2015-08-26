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

#ifndef __starsun_h
#define __starsun_h 1

#if defined(__cplusplus) && !defined(mclmcrrt_h) && defined(__linux__)
#  pragma implementation "mclmcrrt.h"
#endif
#include "mclmcrrt.h"
#ifdef __cplusplus
extern "C" {
#endif

#if defined(__SUNPRO_CC)
/* Solaris shared libraries use __global, rather than mapfiles
 * to define the API exported from a shared library. __global is
 * only necessary when building the library -- files including
 * this header file to use the library do not need the __global
 * declaration; hence the EXPORTING_<library> logic.
 */

#ifdef EXPORTING_starsun
#define PUBLIC_starsun_C_API __global
#else
#define PUBLIC_starsun_C_API /* No import statement needed. */
#endif

#define LIB_starsun_C_API PUBLIC_starsun_C_API

#elif defined(_HPUX_SOURCE)

#ifdef EXPORTING_starsun
#define PUBLIC_starsun_C_API __declspec(dllexport)
#else
#define PUBLIC_starsun_C_API __declspec(dllimport)
#endif

#define LIB_starsun_C_API PUBLIC_starsun_C_API


#else

#define LIB_starsun_C_API

#endif

/* This symbol is defined in shared libraries. Define it here
 * (to nothing) in case this isn't a shared library. 
 */
#ifndef LIB_starsun_C_API 
#define LIB_starsun_C_API /* No special import/export declaration */
#endif

extern LIB_starsun_C_API 
bool MW_CALL_CONV starsunInitializeWithHandlers(
       mclOutputHandlerFcn error_handler, 
       mclOutputHandlerFcn print_handler);

extern LIB_starsun_C_API 
bool MW_CALL_CONV starsunInitialize(void);

extern LIB_starsun_C_API 
void MW_CALL_CONV starsunTerminate(void);



extern LIB_starsun_C_API 
void MW_CALL_CONV starsunPrintStackTrace(void);

extern LIB_starsun_C_API 
bool MW_CALL_CONV mlxStarsun(int nlhs, mxArray *plhs[], int nrhs, mxArray *prhs[]);

extern LIB_starsun_C_API 
bool MW_CALL_CONV mlxStarinfo20120718(int nlhs, mxArray *plhs[], int nrhs, mxArray 
                                      *prhs[]);

extern LIB_starsun_C_API 
bool MW_CALL_CONV mlxStarinfo20130802(int nlhs, mxArray *plhs[], int nrhs, mxArray 
                                      *prhs[]);

extern LIB_starsun_C_API 
bool MW_CALL_CONV mlxStarinfo20130803(int nlhs, mxArray *plhs[], int nrhs, mxArray 
                                      *prhs[]);

extern LIB_starsun_C_API 
bool MW_CALL_CONV mlxStarinfo20130805(int nlhs, mxArray *plhs[], int nrhs, mxArray 
                                      *prhs[]);

extern LIB_starsun_C_API 
bool MW_CALL_CONV mlxStarinfo20130806(int nlhs, mxArray *plhs[], int nrhs, mxArray 
                                      *prhs[]);

extern LIB_starsun_C_API 
bool MW_CALL_CONV mlxStarinfo20130807(int nlhs, mxArray *plhs[], int nrhs, mxArray 
                                      *prhs[]);

extern LIB_starsun_C_API 
bool MW_CALL_CONV mlxStarinfo20130808(int nlhs, mxArray *plhs[], int nrhs, mxArray 
                                      *prhs[]);

extern LIB_starsun_C_API 
bool MW_CALL_CONV mlxStarinfo20130812(int nlhs, mxArray *plhs[], int nrhs, mxArray 
                                      *prhs[]);

extern LIB_starsun_C_API 
bool MW_CALL_CONV mlxStarinfo20130813(int nlhs, mxArray *plhs[], int nrhs, mxArray 
                                      *prhs[]);

extern LIB_starsun_C_API 
bool MW_CALL_CONV mlxStarinfo20130814(int nlhs, mxArray *plhs[], int nrhs, mxArray 
                                      *prhs[]);

extern LIB_starsun_C_API 
bool MW_CALL_CONV mlxStarinfo20130815(int nlhs, mxArray *plhs[], int nrhs, mxArray 
                                      *prhs[]);

extern LIB_starsun_C_API 
bool MW_CALL_CONV mlxStarinfo20130816(int nlhs, mxArray *plhs[], int nrhs, mxArray 
                                      *prhs[]);

extern LIB_starsun_C_API 
bool MW_CALL_CONV mlxStarinfo20130818(int nlhs, mxArray *plhs[], int nrhs, mxArray 
                                      *prhs[]);

extern LIB_starsun_C_API 
bool MW_CALL_CONV mlxStarinfo20130819(int nlhs, mxArray *plhs[], int nrhs, mxArray 
                                      *prhs[]);

extern LIB_starsun_C_API 
bool MW_CALL_CONV mlxStarinfo20130821(int nlhs, mxArray *plhs[], int nrhs, mxArray 
                                      *prhs[]);

extern LIB_starsun_C_API 
bool MW_CALL_CONV mlxStarinfo20130823(int nlhs, mxArray *plhs[], int nrhs, mxArray 
                                      *prhs[]);

extern LIB_starsun_C_API 
bool MW_CALL_CONV mlxStarinfo20130826(int nlhs, mxArray *plhs[], int nrhs, mxArray 
                                      *prhs[]);

extern LIB_starsun_C_API 
bool MW_CALL_CONV mlxStarinfo20130827(int nlhs, mxArray *plhs[], int nrhs, mxArray 
                                      *prhs[]);

extern LIB_starsun_C_API 
bool MW_CALL_CONV mlxStarinfo20130828(int nlhs, mxArray *plhs[], int nrhs, mxArray 
                                      *prhs[]);

extern LIB_starsun_C_API 
bool MW_CALL_CONV mlxStarinfo20130830(int nlhs, mxArray *plhs[], int nrhs, mxArray 
                                      *prhs[]);

extern LIB_starsun_C_API 
bool MW_CALL_CONV mlxStarinfo20130831(int nlhs, mxArray *plhs[], int nrhs, mxArray 
                                      *prhs[]);

extern LIB_starsun_C_API 
bool MW_CALL_CONV mlxStarinfo20130902(int nlhs, mxArray *plhs[], int nrhs, mxArray 
                                      *prhs[]);

extern LIB_starsun_C_API 
bool MW_CALL_CONV mlxStarinfo20130904(int nlhs, mxArray *plhs[], int nrhs, mxArray 
                                      *prhs[]);

extern LIB_starsun_C_API 
bool MW_CALL_CONV mlxStarinfo20130906(int nlhs, mxArray *plhs[], int nrhs, mxArray 
                                      *prhs[]);

extern LIB_starsun_C_API 
bool MW_CALL_CONV mlxStarinfo20130907(int nlhs, mxArray *plhs[], int nrhs, mxArray 
                                      *prhs[]);

extern LIB_starsun_C_API 
bool MW_CALL_CONV mlxStarinfo20130908(int nlhs, mxArray *plhs[], int nrhs, mxArray 
                                      *prhs[]);

extern LIB_starsun_C_API 
bool MW_CALL_CONV mlxStarinfo20130909(int nlhs, mxArray *plhs[], int nrhs, mxArray 
                                      *prhs[]);

extern LIB_starsun_C_API 
bool MW_CALL_CONV mlxStarinfo20130911(int nlhs, mxArray *plhs[], int nrhs, mxArray 
                                      *prhs[]);

extern LIB_starsun_C_API 
bool MW_CALL_CONV mlxStarinfo20130913(int nlhs, mxArray *plhs[], int nrhs, mxArray 
                                      *prhs[]);

extern LIB_starsun_C_API 
bool MW_CALL_CONV mlxStarinfo20130916(int nlhs, mxArray *plhs[], int nrhs, mxArray 
                                      *prhs[]);

extern LIB_starsun_C_API 
bool MW_CALL_CONV mlxStarinfo20130917(int nlhs, mxArray *plhs[], int nrhs, mxArray 
                                      *prhs[]);

extern LIB_starsun_C_API 
bool MW_CALL_CONV mlxStarinfo20130918(int nlhs, mxArray *plhs[], int nrhs, mxArray 
                                      *prhs[]);

extern LIB_starsun_C_API 
bool MW_CALL_CONV mlxStarinfo20130921(int nlhs, mxArray *plhs[], int nrhs, mxArray 
                                      *prhs[]);

extern LIB_starsun_C_API 
bool MW_CALL_CONV mlxStarinfo20130923(int nlhs, mxArray *plhs[], int nrhs, mxArray 
                                      *prhs[]);

extern LIB_starsun_C_API 
bool MW_CALL_CONV mlxStarinfo20130930(int nlhs, mxArray *plhs[], int nrhs, mxArray 
                                      *prhs[]);

extern LIB_starsun_C_API 
bool MW_CALL_CONV mlxStarinfo20140907(int nlhs, mxArray *plhs[], int nrhs, mxArray 
                                      *prhs[]);



extern LIB_starsun_C_API bool MW_CALL_CONV mlfStarsun(int nargout, mxArray** savematfile, mxArray** contents, mxArray* varargin);

extern LIB_starsun_C_API bool MW_CALL_CONV mlfStarinfo20120718();

extern LIB_starsun_C_API bool MW_CALL_CONV mlfStarinfo20130802();

extern LIB_starsun_C_API bool MW_CALL_CONV mlfStarinfo20130803();

extern LIB_starsun_C_API bool MW_CALL_CONV mlfStarinfo20130805();

extern LIB_starsun_C_API bool MW_CALL_CONV mlfStarinfo20130806();

extern LIB_starsun_C_API bool MW_CALL_CONV mlfStarinfo20130807();

extern LIB_starsun_C_API bool MW_CALL_CONV mlfStarinfo20130808();

extern LIB_starsun_C_API bool MW_CALL_CONV mlfStarinfo20130812();

extern LIB_starsun_C_API bool MW_CALL_CONV mlfStarinfo20130813();

extern LIB_starsun_C_API bool MW_CALL_CONV mlfStarinfo20130814();

extern LIB_starsun_C_API bool MW_CALL_CONV mlfStarinfo20130815();

extern LIB_starsun_C_API bool MW_CALL_CONV mlfStarinfo20130816();

extern LIB_starsun_C_API bool MW_CALL_CONV mlfStarinfo20130818();

extern LIB_starsun_C_API bool MW_CALL_CONV mlfStarinfo20130819();

extern LIB_starsun_C_API bool MW_CALL_CONV mlfStarinfo20130821();

extern LIB_starsun_C_API bool MW_CALL_CONV mlfStarinfo20130823();

extern LIB_starsun_C_API bool MW_CALL_CONV mlfStarinfo20130826();

extern LIB_starsun_C_API bool MW_CALL_CONV mlfStarinfo20130827();

extern LIB_starsun_C_API bool MW_CALL_CONV mlfStarinfo20130828();

extern LIB_starsun_C_API bool MW_CALL_CONV mlfStarinfo20130830();

extern LIB_starsun_C_API bool MW_CALL_CONV mlfStarinfo20130831();

extern LIB_starsun_C_API bool MW_CALL_CONV mlfStarinfo20130902();

extern LIB_starsun_C_API bool MW_CALL_CONV mlfStarinfo20130904();

extern LIB_starsun_C_API bool MW_CALL_CONV mlfStarinfo20130906();

extern LIB_starsun_C_API bool MW_CALL_CONV mlfStarinfo20130907();

extern LIB_starsun_C_API bool MW_CALL_CONV mlfStarinfo20130908();

extern LIB_starsun_C_API bool MW_CALL_CONV mlfStarinfo20130909();

extern LIB_starsun_C_API bool MW_CALL_CONV mlfStarinfo20130911();

extern LIB_starsun_C_API bool MW_CALL_CONV mlfStarinfo20130913();

extern LIB_starsun_C_API bool MW_CALL_CONV mlfStarinfo20130916();

extern LIB_starsun_C_API bool MW_CALL_CONV mlfStarinfo20130917();

extern LIB_starsun_C_API bool MW_CALL_CONV mlfStarinfo20130918();

extern LIB_starsun_C_API bool MW_CALL_CONV mlfStarinfo20130921();

extern LIB_starsun_C_API bool MW_CALL_CONV mlfStarinfo20130923();

extern LIB_starsun_C_API bool MW_CALL_CONV mlfStarinfo20130930();

extern LIB_starsun_C_API bool MW_CALL_CONV mlfStarinfo20140907();

#ifdef __cplusplus
}
#endif
#endif
