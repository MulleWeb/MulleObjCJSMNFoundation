//
//  main.m
//  archiver-test
//
//  Created by Nat! on 19.04.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//
#import <MulleObjCJSMNFoundation/MulleObjCJSMNFoundation.h>
//#import "MulleStandaloneObjCFoundation.h"


int   main( int argc, const char * argv[])
{
   NSData                *data;
   NSError               *error;
   id                    plist;
   NSUInteger            format;
   struct mulle_buffer   buffer;
   int                   c;

// don't have that yet :( it's on OS
//   data = [[NSFileHandle fileHandleWithStandardInput] readDataToEndOfFile];

   mulle_buffer_init( &buffer, NULL);
   while( (c = getchar()) != EOF)
      mulle_buffer_add_byte( &buffer, c);

   data = [[[NSData alloc] initWithBytes:mulle_buffer_get_bytes( &buffer)
                                  length:mulle_buffer_get_length( &buffer)] autorelease];
   mulle_buffer_done( &buffer);

   error = nil;
   plist = [NSPropertyListSerialization propertyListWithData:data
                                                     options:0
                                                      format:NULL
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
