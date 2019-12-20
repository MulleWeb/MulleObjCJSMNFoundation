#ifndef mulle_objc_jsmn_foundation_h__
#define mulle_objc_jsmn_foundation_h__

#import "import.h"

#include <stdint.h>

/*
 *  (c) 2019 nat ORGANIZATION
 *
 *  version:  major, minor, patch
 */
#define MULLE_OBJC_JSMN_FOUNDATION_VERSION  ((0 << 20) | (16 << 8) | 0)


static inline unsigned int   MulleObjCJSMNFoundation_get_version_major( void)
{
   return( MULLE_OBJC_JSMN_FOUNDATION_VERSION >> 20);
}


static inline unsigned int   MulleObjCJSMNFoundation_get_version_minor( void)
{
   return( (MULLE_OBJC_JSMN_FOUNDATION_VERSION >> 8) & 0xFFF);
}


static inline unsigned int   MulleObjCJSMNFoundation_get_version_patch( void)
{
   return( MULLE_OBJC_JSMN_FOUNDATION_VERSION & 0xFF);
}


extern uint32_t   MulleObjCJSMNFoundation_get_version( void);

/*
   Add other library headers here like so, for exposure to library
   consumers.

   # include "foo.h"
*/

#import "MulleObjCJSMNParser.h"

#import "MulleObjCLoader+MulleObjCJSMNFoundation.h"

#endif
