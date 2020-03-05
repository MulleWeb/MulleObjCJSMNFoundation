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
static char   test_json[] =
   "{\n"
   "  \"args\": {}, \n"
   "  \"data\": \"\", \n"
   "  \"files\": {}, \n"
   "  \"form\": {\n"
   "    \"VfL Bochum 1848\": \"\"\n"
   "  }, \n"
   "  \"headers\": {\n"
   "    \"Accept\": \"*/*\", \n"
   "    \"Content-Length\": \"15\", \n"
   "    \"Content-Type\": \"application/x-www-form-urlencoded\", \n"
   "    \"Host\": \"httpbin.org\", \n"
   "    \"X-Amzn-Trace-Id\": \"Root=1-5e6120be-8208406083ebbc88e5e6ecc0\"\n"
   "  }, \n"
   "  \"json\": null, \n"
   "  \"origin\": \"94.114.3.142\", \n"
   "  \"url\": \"https://httpbin.org/post\"\n"
   "}\n";



int   main( int argc, const char * argv[])
{
   NSData       *data;
   NSError      *error;
   id           plist;
   NSUInteger   format;
   NSPropertyListFormat   plistFormat;

   error = nil;
   data  = [NSData dataWithBytes:test_json
                          length:sizeof( test_json)];
   plistFormat = MullePropertyListJSONFormat;
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
   printf( "Format: %s\n", [MulleStringFromPropertListFormatString( plistFormat) UTF8String]);

   _MulleObjCJSONSortedDictionary = YES;
   printf( "%s\n", [[plist mulleJSONDescription] UTF8String]);
   return( 0);
}
