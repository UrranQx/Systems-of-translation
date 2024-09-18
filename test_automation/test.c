/* Copy input to output until '.' or EOF. 
   The '.' itself not copied.
*/

#include <stdio.h>
#include <string.h>

#define sz 1024
char buf[sz];

main()
{
    int bcnt;
    char *p;

    bcnt = fread(buf, 1, sz-1, stdin);
    buf[bcnt+1] = 0;
    p = strchr(buf, '.');	// p = NULL if not found
    if (p) {
      bcnt = p - buf;
    } 
    fwrite(buf, 1, bcnt, stdout);
    return 0;
}
