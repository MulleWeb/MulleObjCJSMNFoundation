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
   id                    plist;
   int                   c;
   MulleJSMNParser       *parser;
   struct mulle_buffer   buffer;
   int                   i;
   int                   count;

// don't have that yet :( it's on OS
//   data = [[NSFileHandle fileHandleWithStandardInput] readDataToEndOfFile];

   parser = [MulleJSMNParser object];
   plist  = nil;
   i      = 0;
   count  = 0;

   mulle_buffer_init( &buffer, NULL);
   while( (c = getchar()) != EOF)
   {
      mulle_buffer_add_byte( &buffer, c);
      if( ! plist)
      {
         plist = [parser parseBytes:mulle_buffer_get_bytes( &buffer)
                             length:mulle_buffer_get_length( &buffer)];
      }
      else
         fprintf( stderr, "trailing character '%c'\n", c);
   }
   mulle_buffer_done( &buffer);

   if( ! plist)
   {
      fprintf( stderr, "Failed\n");
      return( 1);
   }

   // not so pretty yet
   printf( "%s\n", [[plist description] UTF8String]);
   return( 0);
}
