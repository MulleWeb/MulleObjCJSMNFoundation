/*
 *  MulleFoundation - A tiny Foundation replacement
 *
 *  NSPropertyListSerialization+ExpatPropertyList.m is a part of MulleFoundation
 *
 *  Copyright (C) 2011 Nat!, Mulle kybernetiK
 *  All rights reserved.
 *
 *  Coded by Nat!
 *
 *  $Id$
 *
 */
#import "import-private.h"

// other files in this library
#import "MulleObjCJSMNParser.h"

// other libraries of MulleObjCStandardFoundation

// std-c and dependencies

@implementation NSPropertyListSerialization( JSMN)


// the detection happens in main standard foundation already
+ (void) load
{
   [self mulleAddParserClass:[MulleObjCJSMNParser class]
       forPropertyListFormat:MullePropertyListJSONFormat];
}

@end
