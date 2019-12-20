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
#import "MulleObjCJSMNParser.h"


#import "import-private.h"

// other files in this library


// other libraries of MulleObjCStandardFoundation

// std-c and dependencies
#include <ctype.h>
#include <errno.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

// strict parsing doesn't buy me a lot, we fix it later as the
// parser is too simple
//#define JSMN_STRICT
#define JSMN_STATIC     // don't expose JSMN functions
#include "jsmn.h"


@implementation MulleObjCJSMNParser

struct process_result
{
   id   obj;
   int  consumed_tokens;
};


static inline struct process_result   *process_result_make( id obj,
                                                            int n,
                                                            struct process_result *space)
{
   space->obj             = obj;
   space->consumed_tokens = n;
   return( space);
}


static inline struct process_result   *process_result_simple( id obj,
                                                              struct process_result *space)
{
   return( process_result_make( obj, 1, space));
}


struct process_context
{
   char                   *js;
   struct process_result  space;
};


static struct process_result  *process_tokens( struct process_context *p,
                                               jsmntok_t *t,
                                               size_t count)
{
   char                    *endptr;
   char                    *start;
   double                  dvalue;
   id                      key;
   id                      obj;
   id                      value;
   int                     i, j, k;
   int                     rval;
   jsmntok_t               *key_token;
   jsmntok_t               *value_token;
   long long               nr;
   mulle_utf8_t            *s;
   size_t                  len;
   struct process_result   *result;

   if( count == 0)
      return( NULL);

   switch( t->type)
   {
   case JSMN_UNDEFINED :
      return( NULL);

   case JSMN_PRIMITIVE :
      len   = (size_t) (t->end - t->start);
      start = p->js + t->start;
      switch( *start)
      {
      case 'n' :
         if( len == 4 && ! strncmp( start, "null", len))
            return( process_result_simple( [NSNull null], &p->space));
         break;

      case 't' :
         if( len == 4 && ! strncmp( start, "true", len))
            return( process_result_simple( @(YES), &p->space));
         break;

      case 'f' :
         if( len == 5 && ! strncmp( start, "false", len))
            return( process_result_simple( @(NO), &p->space));
         break;

      case '0' :
      case '1' :
      case '2' :
      case '3' :
      case '4' :
      case '5' :
      case '6' :
      case '7' :
      case '8' :
      case '9' :
      case '-' :
         s    = (mulle_utf8_t *) start;
         rval = _mulle_utf8_scan_longlong_decimal( &s, len, &nr);
         if( rval < 0)
            return( NULL);
         // consumed all, than its integer
         if( s == (mulle_utf8_t *) &start[ len])
         {
            if( rval == mulle_utf_is_too_large_for_signed)
            {
               obj = [[NSNumber alloc] initWithUnsignedLongLong:(unsigned long long) nr];
               return( process_result_simple( obj, &p->space));
            }

            assert( rval == mulle_utf_is_valid);
            {
               obj = [[NSNumber alloc] initWithLongLong:nr];
               return( process_result_simple( obj, &p->space));
            }
         }

         // could be a float though, but only if we can convert all
         dvalue = strtod( start, &endptr);
         if( endptr == &start[ len])
         {
            obj = [[NSNumber alloc] initWithDouble:dvalue];
            return( process_result_simple( obj, &p->space));
         }
      }
      return( NULL);

   case JSMN_STRING :
      len   = t->end - t->start;
      start = p->js + t->start;
      s     = (mulle_utf8_t *) start;
      obj   = [[NSString alloc] mulleInitWithUTF8Characters:s
                                                     length:len];
      return( process_result_simple( obj, &p->space));

   case JSMN_OBJECT :
      j   = 0;
      obj = [NSMutableDictionary new];

      for( i = 0; i < t->size; i++)
      {
         key_token  = &t[ 1 + j];
         // a possibly previous result will be invalid now as space is reused
         result = process_tokens( p, key_token, count - j);
         if( ! result)
         {
            [obj autorelease];
            return( NULL);
         }

         key    = result->obj;
         j     += result->consumed_tokens;
         value  = @"";
         if( key_token->size > 0)
         {
            value_token  = &t[ 1 + j];

            // a previous result will be invalid now as space is reused
            result = process_tokens( p, value_token, count - j);
            if( ! result)
            {
               [obj autorelease];
               [key autorelease];
               return( NULL);
            }

            value = result->obj;
            j    += result->consumed_tokens;
         }
         [obj mulleSetRetainedObject:value
                        forCopiedKey:key];
      }
      return( process_result_make( obj, j + 1, &p->space));

   case JSMN_ARRAY     :
       j   = 0;
       obj = [NSMutableArray new];

       for( i = 0; i < t->size; i++)
       {
         value_token = &t[ 1 + j];
         result      = process_tokens( p, value_token, count - j);
         if( ! result)
         {
            [obj autorelease];
            return( NULL);
         }

         value  = result->obj;
         j     += result->consumed_tokens;
         [obj mulleAddRetainedObject:value];
       }
       return( process_result_make( obj, j + 1, &p->space));
   }
   return( NULL);
}


- (id) init
{
   assert( sizeof( jsmn_parser) <= sizeof( self->_space));
   assert( alignof( jsmn_parser) <= alignof( self->_space));

   _parser = _space;
   [self reset];

   return( self);
}


- (void) reset
{
   jsmn_init( _parser);

   _tokcount   = 512;
   _tok        = mulle_allocator_realloc( MulleObjCObjectGetAllocator( self),
                                          _tok,
                                          sizeof( jsmntok_t) * _tokcount);
   _incomplete = NO;
}


- (void) dealloc
{
   mulle_allocator_free( MulleObjCObjectGetAllocator( self), _tok);
   [super dealloc];
}


- (id) parseData:(NSData *) data
{
   return( [self parseBytes:[data bytes]
                     length:[data length]]);
}


- (id) parseBytes:(void *) bytes
           length:(NSUInteger) length
{
   id                       plist;
   int                      rval;
   struct process_result    space;
   struct process_result    *result;
   struct process_context   ctxt;

   plist = nil;

  /* Allocate some tokens as a start */
again:
   rval = jsmn_parse( _parser, bytes, length, _tok, _tokcount);
   if( rval < 0)
   {
      if( rval == JSMN_ERROR_NOMEM)
      {
         assert( _tokcount);
         _tokcount = _tokcount * 2;
         _tok      = mulle_allocator_realloc( MulleObjCObjectGetAllocator( self),
                                              _tok,
                                              sizeof( jsmntok_t) * _tokcount);
         goto again;
      }
      if( rval == JSMN_ERROR_PART)
         _incomplete = YES;
   }
   else
   {
      ctxt.js = bytes;
      result  = process_tokens( &ctxt, _tok, rval);
      if( result)
         plist = [result->obj autorelease];
   }

   return( plist);
}


- (id) mulleParsePropertyListData:(NSData *) data
                 mutabilityOption:(NSPropertyListMutabilityOptions) opt
{
   // options are ignored, as everything is mutable anyway
   return( [self parseData:data]);
}

@end



