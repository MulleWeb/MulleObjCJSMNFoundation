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
static char   test_json[] = "-18.48e+10";



int   main( int argc, const char * argv[])
{
   NSData                 *data;
   NSError                *error;
   id                     plist;
   NSUInteger             format;
   NSPropertyListFormat   plistFormat;

   error = nil;
   data  = [NSData dataWithBytes:test_json
                          length:sizeof( test_json)];
   plistFormat = MullePropertyListLooseFormat;
   plist = [NSPropertyListSerialization propertyListWithData:data
                                                     options:0
                                                      format:&plistFormat
                                                       error:&error];
   if( ! plist)
   {
      fprintf( stderr, "Error: %s\n", [[error description] UTF8String]);
      return( 1);
   }

   // not so pretty yet
   printf( "%s\n", [[plist description] UTF8String]);
   return( 0);
}
