#include <stdio.h>
#include <ctype.h>
// #include <unistd.h>
#include <errno.h>
#include <stdlib.h>

#include "scanner.h"

/* ------- Global data ------- */

char    yytext[1024];
int     yyleng;
YYSTYPE yylval;

/* ------- Local macros and functions ------- */

#define unput(c) { ungetc(c, stdin); yytext[--yyleng] = 0; }

/*
 *  Read and save a char from stdio, used by __yylex()
 */
static int input ()
{
    int c;

    c = getchar();
    if (c == EOF) c = 0;
    yytext[yyleng++] = c;
    return c;
}

/*
 * Convert yytext to yylval with overflow checking
 */
static void convert (int base)
{
    long long int x;

    
    x = strtoll (yytext, NULL, 10);
    yylval = x;
    if (errno == ERANGE || yylval != x) { 
        fprintf(stderr, "\nFatal error: number %s is too big\n", yytext);
	    exit(1);
    }
}


/*
 *  Get next token from stdio, used by yylex()
 */
static int __yylex ()
{
    int c, state;
 

    for (state = 0; ; ) {
        c = input();
        switch(state) {
          case 0:               /* skip whitespaces */
            if (isspace(c)) {   
                yyleng = 0;
                break;
            }               

            if (isalpha(c)) {
                state = 1;      /* treat next chars as Identifier */
                break;
            }
            if (isdigit(c)) {   
                state = 2;      /* treat next chars as Number */
                break;
            }

            return c;           /* return one-char Literal */

          case 1:               /* build Identifier */
            if (!isalnum(c)) {
                unput(c);
                return ID;
            }               
            break;

          case 2:               /* build Number */
            if (!isdigit(c)) {
                unput(c);
                convert(10);
                return NUM;
            }
            break;

          default:
            fprintf(stderr, "\nFatal error: yylex is in unknown state\n");
            exit(1);        
        }
    }
}

/* ------- Global functions ------- */

/*
 *  Get next token from stdin
 */
int yylex()
{
    int token;

    yyleng = 0;
    token = __yylex();
    yytext[yyleng] = 0;     /* zero-end the string */
    return token;
}   

/* 
 *  Print token as char or, if it's invisible, as decimal ASCII 
 */
int prn_token (int token)
{
    fprintf(stderr, isprint(token) ? "'%c' " : "\\%d ", token);
    return token;
}   


