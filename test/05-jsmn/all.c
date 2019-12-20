//#define JSMN_STRICT
#include <MulleObjCJSMNFoundation/jsmn.h>
#include <stdio.h>
#include <string.h>


static char  *json = "[\n"
"   -1849,\n"
"   18.48e+10,\n"
"   true,\n"
"   false,\n"
"   null,\n"
"   truex\n"
"]";


int main( void)
{
   jsmn_parser   p;
   jsmntok_t     t[128];
   int           r;
   int           i;

   jsmn_init( &p);
   r = jsmn_parse(&p, json, strlen( json), t, 128);
   if( r < 0)
   {
      fprintf( stderr, "Failed to parse JSON: %d\n", r);
      return 1;
   }
   for( i = 0; i < r; i++)
      printf( "%.*s\n", t[ i].end - t[ i].start, &json[ t[ i].start]);
   return( 0);
}
