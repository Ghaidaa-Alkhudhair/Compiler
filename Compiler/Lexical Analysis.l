%{
#include "Phase2.h"
#include "Phase2.tab.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

%}
%option yylineno   
digits     -?0|[1-9][0-9]*
double     -?[0-9]+\.[0-9]+
identifier [A-Z][0-9A-Za-z_]*
string     [\"][^\"]*[\"]|[\"][A-Z][0-9A-Za-z_]*[\"]
whitespace [" "\t] 
comment    @[^@]*@
%%
"START" {return START;}
"END" { return END;}  
"int" {return INT;}
"double" {return DOUBLE;}
"if" { return IF;}
"then" { return THEN;}
"else" { return ELSE;}
"end" { return IFEND;}
"read" { return READ;}
"write" { return WRITE;}
"repeat" { return REPEAT;}
"until" { return UNTIL;}
"+" { return PLUS;}
"-" { return MINUS;}
"*" { return MULT;}
"/" { return DIV;}
"==" {return(EQ);}
"<" {return(LT);}
"<=" {return(LE);}
">" {return(GT);}
">=" {return(GE);}
"<>" {return(NE);}
"(" {return(LPAREN);}
")" {return(RPAREN);}
":=" { return ASSIGN;}
";" { return ';';}
{digits} { return INT_LITERAL;}
{double} { return DBL_LITERAL;}
{identifier} {strcpy( (yylval.s).name , yytext); return ID;}
{string} {STRING_LITERAL;}
{whitespace}* {;}
[\n] {;}
{comment}  {;}
. {return *yytext; }
%%
