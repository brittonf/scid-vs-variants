/* ======================================================================
 * Author : $Author$
 * Version: $Revision: 102 $
 * Date   : $Date: 2011-11-10 15:04:49 +0100 (Thu, 10 Nov 2011) $
 * Url    : $URL$
 * ====================================================================== */

#ifndef nstypes_h___
#define nstypes_h___

#include <stdint.h>
#include <stddef.h>

extern "C" {

/************************************************************************
** TYPES:       PRUint8
**              PRInt8
** DESCRIPTION:
**  The int8 types are known to be 8 bits each. There is no type that
**      is equivalent to a plain "char". 
************************************************************************/
typedef uint8_t PRUint8;
typedef int8_t PRInt8;

/************************************************************************
** TYPES:       PRUint16
**              PRInt16
** DESCRIPTION:
**  The int16 types are known to be 16 bits each. 
************************************************************************/
typedef uint16_t PRUint16;
typedef int16_t PRInt16;

/************************************************************************
** TYPES:       PRUint32
**              PRInt32
** DESCRIPTION:
**  The int32 types are known to be 32 bits each. 
************************************************************************/
typedef uint32_t PRUint32;
typedef int32_t PRInt32;

#define PR_INT32(x)  INT32_C(x)
#define PR_UINT32(x) UINT32_C(x)

/************************************************************************
** TYPES:       PRUint64
**              PRInt64
** DESCRIPTION:
**  The int64 types are known to be 64 bits each. Care must be used when
**      declaring variables of type PRUint64 or PRInt64. Different hardware
**      architectures and even different compilers have varying support for
**      64 bit values. The only guaranteed portability requires the use of
**      the LL_ macros (see prlong.h).
************************************************************************/
typedef uint64_t PRUint64;
typedef int64_t PRInt64;

/************************************************************************
** TYPES:       PRUintn
**              PRIntn
** DESCRIPTION:
**  The PRIntn types are most appropriate for automatic variables. They are
**      guaranteed to be at least 16 bits, though various architectures may
**      define them to be wider (e.g., 32 or even 64 bits). These types are
**      never valid for fields of a structure. 
************************************************************************/
typedef int PRIntn;
typedef unsigned int PRUintn;

/************************************************************************
** TYPES:       PRFloat64
** DESCRIPTION:
**  NSPR's floating point type is always 64 bits. 
************************************************************************/
typedef double          PRFloat64;

/************************************************************************
** TYPES:       PRSize
** DESCRIPTION:
**  A type for representing the size of objects. 
************************************************************************/
typedef size_t PRSize;

/************************************************************************
** TYPES:       PRPtrDiff
** DESCRIPTION:
**  A type for pointer difference. Variables of this type are suitable
**      for storing a pointer or pointer sutraction. 
************************************************************************/
typedef ptrdiff_t PRPtrdiff;

/************************************************************************
** TYPES:       PRUptrdiff
** DESCRIPTION:
**  A type for pointer difference. Variables of this type are suitable
**      for storing a pointer or pointer sutraction. 
************************************************************************/
typedef unsigned long PRUptrdiff;

/************************************************************************
** TYPES:       PRBool
** DESCRIPTION:
**  Use PRBool for variables and parameter types. Use PR_FALSE and PR_TRUE
**      for clarity of target type in assignments and actual arguments. Use
**      'if (bool)', 'while (!bool)', '(bool) ? x : y' etc., to test booleans
**      juast as you would C int-valued conditions. 
************************************************************************/
typedef PRIntn PRBool;
#define PR_TRUE (PRIntn)1
#define PR_FALSE (PRIntn)0

/************************************************************************
** TYPES:       PRPackedBool
** DESCRIPTION:
**  Use PRPackedBOol within structs where bitfields are not desireable
**      but minimum and consistant overhead matters.
************************************************************************/
typedef PRUint8 PRPackedBool;

} /* extern "C" */

/**
 * Generic XPCOM result data type
 */
typedef PRUint32 nsresult;

#endif /* nstypes_h___ */

/* vi: set ts=2 sw=2 et: */
