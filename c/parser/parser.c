#include <stdio.h>
#include <ctype.h>
#include <unistd.h>
#include "scanner.h"
#include "parser.h"

/* --- Local helpers --- */

/*  
 *  Check token against an array of tokens (zero ended) 
 */
static int in (int token, int *p)
{
    for (; (*p) && (*p != token); p++);
    return (*p == token);
}

/* ------- Global functions ------- */

/*
 *  Check token with error report and abortion
 */
int chk_token (int token, int *p)
{
    if (!in(token, p)) {
        fprintf(stderr, "Token ");
        prn_token(token);
        fprintf(stderr, "\nExpected ");
        for (; *p; p++)
            prn_token(*p);
        fprintf(stderr, "\n");
        exit(1);
    }
    return token;
}

/*  
 *  Get next token, check-abort 
 */
int rd_token (int *p)
{
    return chk_token(yylex(), p);
}

/* 
 *  Tell of misplaced EOF, abort 
 */
void bad_eof (void)
{
    fprintf(stderr, "Error: Unexpected EOF\n");
    exit(1);
}   
