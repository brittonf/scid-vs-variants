#ifndef __TCLMY_H__
#define __TCLMY_H__

#ifndef _MSC_VER
   #include <unistd.h>
#endif
  #define PRINT_MEM(x) { int pid = getpid(); fprintf(stderr, "======== " x "\t"); \
  char cmd[256]; \
  sprintf(cmd, "more /proc/%d/status | grep VmData", pid); \
  system(cmd);}

extern int logMemory;

#ifdef WINCE

#include <tcl.h>

extern Tcl_Interp * currentTclInterp;

#ifdef __cplusplus
extern "C" {
#endif /* __cplusplus */

char *  my_Tcl_Alloc(int size);
char *  my_Tcl_Realloc(char * ptr, int size);
char *  my_Tcl_AttemptAlloc(int size);
void    my_Tcl_Free(char * ptr);

Tcl_Channel my_Tcl_OpenFileChannel (Tcl_Interp * interp, CONST char * fileName, CONST char * modeString, int permissions);
Tcl_Channel mySilent_Tcl_OpenFileChannel (Tcl_Interp * interp, CONST char * fileName, CONST char * modeString, int permissions);
int my_Tcl_Close (Tcl_Interp * interp, Tcl_Channel chan);
int my_Tcl_Read (Tcl_Channel chan, char * bufPtr, int toRead);
int my_Tcl_Write (Tcl_Channel chan, CONST char * s, int slen);
int my_Tcl_Flush (Tcl_Channel chan);
Tcl_WideInt  my_Tcl_Seek (Tcl_Channel chan, Tcl_WideInt offset, int mode);
Tcl_WideInt  my_Tcl_Tell (Tcl_Channel chan);
int my_Tcl_SetChannelOption ( Tcl_Interp * interp, Tcl_Channel chan, CONST char * optionName, CONST char * newValue);
int my_Tcl_Eof (Tcl_Channel chan);

#ifdef __cplusplus
}
#endif
#endif
#endif
