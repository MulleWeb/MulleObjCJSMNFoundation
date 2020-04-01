//
//  main.m
//  archiver-test
//
//  Created by Nat! on 19.04.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//
#import <MulleObjCJSMNFoundation/MulleObjCJSMNFoundation.h>
//#import "MulleStandaloneObjCFoundation.h"


//
// Dates can not be tested, because we need the POSIX Foundation or the
// equivalent, which provides the NSDateFormatter functionality
//
//
// stolen randomly from https://github.com/jagill/JAGPropertyConverter
//
static char   test_json[] = "[\n"
"   -1849,\n"
"   18.48e+10,\n"
"   true,\n"
"   false,\n"
"   null,\n"
"   { \"key\": \"value\" }\n"
"]";



int   main( int argc, const char * argv[])
{
   MulleJSMNParser   *parser;
   id                    plist;
   NSUInteger            i;
   NSUInteger            length;

   parser = [[MulleJSMNParser new] autorelease];
   length = strlen( test_json);
   for( i = 1; i < length; i++)
   {
      plist = [parser parseBytes:test_json
                          length:strlen( test_json)];
      if( plist)
         break;
   }

   if( ! plist)
   {
      fprintf( stderr, "failed\n");
      return( 1);
   }

   // not so pretty yet
   printf( "%s\n", [[plist description] UTF8String]);
   return( 0);
}
