%{
	#include <stdio.h>
	#include <stdlib.h>
	#include "si.tab.h"
	
	#define DEBUGSF 
	
	#ifdef DEBUGSF
		#define debugFlex(a) (printf("\n%d: Token=<ID, lexeme>=<%d, %s>\n", yylineno, a, yytext))
	#else 
		#define debugFlex(a)
	#endif
%}

%option yylineno
%option noyywrap

%%

".. ..-."                     	{ debugFlex( IF ); return IF; }
"... .... --- .--"            	{ debugFlex( PRINT ); return PRINT; }
".. -. -"                     	{ debugFlex( INT ); return INT; }
".-- .... .. .-.. ."           	{ debugFlex( WHILE ); return WHILE; }
". .-.. ... ."                	{ debugFlex( ELSE ); return ELSE; }
"... - .-. .. -. --."         	{ debugFlex( STRING ); return STRING; }
@@[\. \s -]+@@			{ debugFlex( IDENTIFIER ); yylval.identifier = strdup(yytext); return IDENTIFIER;}
"<<"                           	{ debugFlex( IF_OPEN ); return IF_OPEN; }
">>"                            { debugFlex( IF_CLOSE ); return IF_CLOSE; }
"#"                            	{ debugFlex( WHILE_OPEN ); return WHILE_OPEN; }
"##"                           	{ debugFlex( WHILE_CLOSE ); return WHILE_CLOSE; }
"|"                            	{ debugFlex( MINUS ); return MINUS; }
":="                           	{ debugFlex( ASSIGNMENT ); return ASSIGNMENT; }
"("                            	{ debugFlex( LPAREN ); return LPAREN; }
")"                            	{ debugFlex( RPAREN ); return RPAREN; }
\"[^\"\n]*\"                   	{ debugFlex( STRING_LITERAL ); yylval.string_val = strdup(yytext); return STRING_LITERAL; }
[0-9]+                         	{ debugFlex( INTEGER_LITERAL ); yylval.int_val = atoi(yytext); return INTEGER_LITERAL; }
\n                             	;
">"				{ debugFlex( GREATER_THAN ); return GREATER_THAN; }
"<"				{ debugFlex( LESS_THAN ); return LESS_THAN; }
"=="				{ debugFlex( EQUAL_TO ); return EQUAL_TO; }
[ \t]                          	; /* ignore whitespace */
"......." 			;
"+" | "*" | "\/"                      {return yytext[0];}
.                              	{ printf(stderr, "Lexical error at line %d: Unknown token '%s'\n", yylineno, yytext); exit(EXIT_FAILURE);}

%%