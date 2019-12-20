/*
 *  MulleFoundation - A tiny Foundation replacement
 *
 *  NSPropertyListSerialization+ExpatPropertyList.m is a part of MulleFoundation
 *
 *  Copyright (C) 2019 Nat!, Mulle kybernetiK
 *  All rights reserved.
 *
 *  Coded by Nat!
 *
 *  $Id$
 *
 */
#import "import.h"


//
// Parser base on JSMN, this can do incremental parsing
//
@interface MulleObjCJSMNParser : NSObject <MulleObjCPlistParser>
{
   void     *_parser;
   void     *_tok;
   size_t   _tokcount;
   int      _error;

   // space _parser will be saved in (if it fits)
   void     *_space[ 4];
}

@property( getter=isIncomplete) BOOL  incomplete;

//
// you can call this incrementally.. if you get
// nil back, check for -isIncomplete, if yes you can append stuff to the NSData
// and try again. It would be a mistake to send a different NSData! For that
// you need to all -reset first
//
- (id) parseData:(NSData *) data;
- (id) parseBytes:(void *) bytes
           length:(NSUInteger) length;

- (void) reset;

@end

