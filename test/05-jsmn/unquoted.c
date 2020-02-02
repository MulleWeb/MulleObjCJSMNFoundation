#define JSMN_STRICT
#include <MulleObjCJSMNFoundation/jsmn.h>
#include <stdio.h>
#include <string.h>


static char  *json = "[\n"
"   thanx\n"
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
      printf( "%d: %.*s (%d)\n", i, t[ i].end - t[ i].start, &json[ t[ i].start], t[i].type);
   return( 0);
}
