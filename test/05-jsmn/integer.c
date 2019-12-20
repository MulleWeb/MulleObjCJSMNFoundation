//#define JSMN_STRICT
#include <MulleObjCJSMNFoundation/jsmn.h>
#include <stdio.h>
#include <string.h>


static char  *json = "1";


int main( void)
{
   jsmn_parser   p;
   jsmntok_t     t[128];
   int           r;

   jsmn_init( &p);
   r = jsmn_parse(&p, json, strlen( json), t, 128);
   if( r < 0)
   {
      fprintf( stderr, "Failed to parse JSON: %d\n", r);
      return 1;
   }
   printf( "%.*s\n", t[ 0].end - t[ 0].start, &json[ t[ 0].start]);
   return( 0);
}
