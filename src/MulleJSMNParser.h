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
//TODO: rename to MulleObjCJSMNPlistParser

@interface MulleJSMNParser : NSObject
{
   void      *_parser;
   void      *_tok;
   size_t    _tokcount;
   int       _error;
   // space _parser will be saved in (if it fits)
   void     *_space[ 4];
}

@property( getter=isIncomplete) BOOL  incomplete;
@property BOOL  trueFalseAsStrings;

// userInfo and object properties will be cleared on -reset
@property( retain) id   userInfo;
@property( retain) id   object;

//
// you can call this incrementally.. if you get
// nil back, check for -isIncomplete, if yes you can *append* stuff to
// the NSData and try again. The already parsed part of the NSData will
// not be parsed again.
// Otherwise you get the parsed object back. It will also be available
// via -object until the next parseData completes.

- (id) parseData:(NSData *) data;

//
// This is the same as above, but you don't wrap it in an NSData
// if you use it incrementally DONT send -parseBytes:"[" length:1
// and then -parseBytes:"]" length:1
// send parseBytes:"[" length:1 and then parseBytes:"[]" length:2
//
- (id) parseBytes:(void *) bytes
           length:(NSUInteger) length;

- (void) reset;

// internal error report generator
- (NSError *) errorWithName:(NSString *) name
                      bytes:(void *) bytes
                     length:(NSUInteger) length
                      range:(NSRange) range;
@end


@interface NSString( MulleJSMNParser)

- (id) mulleJSON;

@end



