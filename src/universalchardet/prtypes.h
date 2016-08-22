/* ======================================================================
 * Author : $Author$
 * Version: $Revision: 102 $
 * Date   : $Date: 2011-11-10 15:04:49 +0100 (Thu, 10 Nov 2011) $
 * Url    : $URL$
 * ====================================================================== */
/*
 * The contents of this file are subject to the Netscape Public License
 * Version 1.0 (the "NPL"); you may not use this file except in
 * compliance with the NPL.  You may obtain a copy of the NPL at
 * http://www.mozilla.org/NPL/
 * 
 * Software distributed under the NPL is distributed on an "AS IS" basis,
 * WITHOUT WARRANTY OF ANY KIND, either express or implied. See the NPL
 * for the specific language governing rights and limitations under the
 * NPL.
 * 
 * The Initial Developer of this code under the NPL is Netscape
 * Communications Corporation.  Portions created by Netscape are
 * Copyright (C) 1998 Netscape Communications Corporation.  All Rights
 * Reserved.
 */

/*
** File:                prtypes.h
** Description: Definitions of NSPR's basic types
**
** Prototypes and macros used to make up for deficiencies in ANSI environments
** that we have found.
**
** Since we do not wrap <stdlib.h> and all the other standard headers, authors
** of portable code will not know in general that they need these definitions.
** Instead of requiring these authors to find the dependent uses in their code
** and take the following steps only in those C files, we take steps once here
** for all C files.
**/

#ifndef prtypes_h___
#define prtypes_h___

/*#include "prcpucfg.h"*/

#include <stddef.h>

/***********************************************************************
** MACROS:      PR_EXTERN
**              PR_IMPLEMENT
** DESCRIPTION:
**      These are only for externally visible routines and globals.  For
**      internal routines, just use "extern" for type checking and that
**      will not export internal cross-file or forward-declared symbols.
**      Define a macro for declaring procedures return types. We use this to
**      deal with windoze specific type hackery for DLL definitions. Use
**      PR_EXTERN when the prototype for the method is declared. Use
**      PR_IMPLEMENT for the implementation of the method.
**
** Example:
**   in dowhim.h
**     PR_EXTERN( void ) DoWhatIMean( void );
**   in dowhim.c
**     PR_IMPLEMENT( void ) DoWhatIMean( void ) { return; }
**
**
***********************************************************************/
#if defined(WIN32)
#define PR_EXTERN(__type) extern _declspec(dllexport) __type
#define PR_IMPLEMENT(__type) _declspec(dllexport) __type
#define PR_EXTERN_DATA(__type) extern _declspec(dllexport) __type
#define PR_IMPLEMENT_DATA(__type) _declspec(dllexport) __type

#define PR_CALLBACK
#define PR_CALLBACK_DECL
#define PR_STATIC_CALLBACK(__x) static __x

#elif defined(WIN16)

#define PR_CALLBACK_DECL        __cdecl

#if defined(_WINDLL)
#define PR_EXTERN(__type) extern __type _cdecl _export _loadds
#define PR_IMPLEMENT(__type) __type _cdecl _export _loadds
#define PR_EXTERN_DATA(__type) extern __type _export
#define PR_IMPLEMENT_DATA(__type) __type _export

#define PR_CALLBACK             __cdecl __loadds
#define PR_STATIC_CALLBACK(__x) static __x PR_CALLBACK

#else /* this must be .EXE */
#define PR_EXTERN(__type) extern __type _cdecl _export
#define PR_IMPLEMENT(__type) __type _cdecl _export
#define PR_EXTERN_DATA(__type) extern __type _export
#define PR_IMPLEMENT_DATA(__type) __type _export

#define PR_CALLBACK             __cdecl __loadds
#define PR_STATIC_CALLBACK(__x) __x PR_CALLBACK
#endif /* _WINDLL */

#elif defined(XP_MAC)
#define PR_EXTERN(__type) extern __declspec(export) __type
#define PR_IMPLEMENT(__type) __declspec(export) __type
#define PR_EXTERN_DATA(__type) extern __declspec(export) __type
#define PR_IMPLEMENT_DATA(__type) __declspec(export) __type

#define PR_CALLBACK
#define PR_CALLBACK_DECL
#define PR_STATIC_CALLBACK(__x) static __x

#elif defined(XP_OS2) 
#define PR_EXTERN(__type) extern __type
#define PR_IMPLEMENT(__type) __type
#define PR_EXTERN_DATA(__type) extern __type
#define PR_IMPLEMENT_DATA(__type) __type
#define PR_CALLBACK
#define PR_CALLBACK_DECL
#define PR_STATIC_CALLBACK(__x) __x _Optlink

#else /* Unix */
#define PR_EXTERN(__type) extern __type
#define PR_IMPLEMENT(__type) __type
#define PR_EXTERN_DATA(__type) extern __type
#define PR_IMPLEMENT_DATA(__type) __type
#define PR_CALLBACK
#define PR_CALLBACK_DECL
#define PR_STATIC_CALLBACK(__x) static __x

#endif

#if !defined(NO_NSPR_10_SUPPORT)
#define PR_PUBLIC_API		PR_IMPLEMENT
#endif

/***********************************************************************
** MACROS:      PR_BEGIN_MACRO
**              PR_END_MACRO
** DESCRIPTION:
**      Macro body brackets so that macros with compound statement definitions
**      behave syntactically more like functions when called.
***********************************************************************/
#define PR_BEGIN_MACRO  do {
#define PR_END_MACRO    } while (0)

/***********************************************************************
** MACROS:      PR_BEGIN_EXTERN_C
**              PR_END_EXTERN_C
** DESCRIPTION:
**      Macro shorthands for conditional C++ extern block delimiters.
***********************************************************************/
#ifdef __cplusplus
#define PR_BEGIN_EXTERN_C       extern "C" {
#define PR_END_EXTERN_C         }
#else
#define PR_BEGIN_EXTERN_C
#define PR_END_EXTERN_C
#endif

/***********************************************************************
** MACROS:      PR_BIT
**              PR_BITMASK
** DESCRIPTION:
** Bit masking macros.  XXX n must be <= 31 to be portable
***********************************************************************/
#define PR_BIT(n)       ((PRUint32)1 << (n))
#define PR_BITMASK(n)   (PR_BIT(n) - 1)

/***********************************************************************
** MACROS:      PR_ROUNDUP
**              PR_MIN
**                              PR_MAX
** DESCRIPTION:
**      Commonly used macros for operations on compatible types.
***********************************************************************/
#define PR_ROUNDUP(x,y) ((((x)+((y)-1))/(y))*(y))
#define PR_MIN(x,y)     ((x)<(y)?(x):(y))
#define PR_MAX(x,y)     ((x)>(y)?(x):(y))

#include "nstypes.h"

PR_BEGIN_EXTERN_C

/*
** Status code used by some routines that have a single point of failure or 
** special status return.
*/
typedef enum { PR_FAILURE = -1, PR_SUCCESS = 0 } PRStatus;

#if defined(NO_NSPR_10_SUPPORT)
#else
/********* ???????????????? FIX ME       ??????????????????????????? *****/
/********************** Some old definitions until pr=>ds transition is done ***/
/********************** Also, we are still using NSPR 1.0. GC ******************/
/*
** Fundamental NSPR macros, used nearly everywhere.
*/

/*
** Macro body brackets so that macros with compound statement definitions
** behave syntactically more like functions when called.
*/
#define NSPR_BEGIN_MACRO        do {
#define NSPR_END_MACRO          } while (0)

/*
** Macro shorthands for conditional C++ extern block delimiters.
*/
#ifdef NSPR_BEGIN_EXTERN_C
#undef NSPR_BEGIN_EXTERN_C
#endif
#ifdef NSPR_END_EXTERN_C
#undef NSPR_END_EXTERN_C
#endif

#ifdef __cplusplus
#define NSPR_BEGIN_EXTERN_C     extern "C" {
#define NSPR_END_EXTERN_C       }
#else
#define NSPR_BEGIN_EXTERN_C
#define NSPR_END_EXTERN_C
#endif

/*
** A PRWord is an integer that is the same size as a void*
*/
typedef long PRWord;
typedef unsigned long PRUword;

/********* ????????????? End Fix me ?????????????????????????????? *****/
#endif /* NO_NSPR_10_SUPPORT */

/*#ifdef XP_MAC
#include "protypes.h"
#else
#include "obsolete/protypes.h"
#endif*/

PR_END_EXTERN_C

#endif /* prtypes_h___ */

/* vi:set ts=4 sw=4 et: */
