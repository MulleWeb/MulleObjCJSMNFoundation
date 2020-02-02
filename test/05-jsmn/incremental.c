//#define JSMN_STRICT
#include <MulleObjCJSMNFoundation/jsmn.h>
#include <stdio.h>
#include <string.h>

#define INCREMENTAL

static char  *json = "[\n"
"   1848,\n"
"   {\n"
"      \"key\": true\n"
"   }\n"
"]";


int main( void)
{
   jsmn_parser   p;
   jsmntok_t     t[128];
   int           r;
   int           i;
   size_t        len;

   jsmn_init( &p);

   len = strlen( json);

#ifdef INCREMENTAL
   for( i = 1; i <= len; i++)
   {
      r = jsmn_parse(&p, json, i, t, 128);
      if( r < 0)
      {
         if( r == JSMN_ERROR_PART)
            continue;
         fprintf( stderr, "Failed to parse JSON: %d\n", r);
         return 1;
      }
      break;
   }
#else
   r = jsmn_parse( &p, json, len, t, 128);
   if( r < 0)
   {
      fprintf( stderr, "Failed to parse JSON: %d\n", r);
      return 1;
   }
#endif
   for( i = 0; i < r; i++)
      printf( "%d: %.*s\n", i, t[ i].end - t[ i].start, &json[ t[ i].start]);
   return( 0);
}
