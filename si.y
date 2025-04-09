%{
	#include <stdio.h>
	#include <stdlib.h>
	extern int yyparse();
	extern int yylex();
	extern FILE* yyin;
	void yyerror(const char *s);
	
	#define DEBUGBISON
	
	#ifdef DEBUGBISON
		#define debugBison(a) (printf("\n%d \n", a))
	#else 
		#define debugBison(a)
	#endif
%}

%union {
	char* identifier;
	char* string_val;
	int int_val;
}

%token IF 
%token PRINT 
%token INT
%token WHILE 
%token ELSE
%token STRING 
%token IDENTIFIER 
%token IF_OPEN 
%token IF_CLOSE 
%token WHILE_OPEN 
%token WHILE_CLOSE 
%token MINUS 
%token ASSIGNMENT  
%token LPAREN 
%token RPAREN
%token STRING_LITERAL
%token INTEGER_LITERAL 
%token GREATER_THAN 
%token LESS_THAN
%token EQUAL_TO

%left '+' MINUS
%left '*' '/'
%left LPAREN RPAREN 


%start program

%% 

program : statement_list									{debugBison(1);}
        | /* empty */										{debugBison(2);}
        ;

statement_list : statement  statement_list							{debugBison(3);}
               | statement 									{debugBison(4);}
               ;

statement : assignment_statement								{debugBison(5);}
          | if_statement									{debugBison(6);}
          | while_statement									{debugBison(7);}
          | print_statement									{debugBison(8);}
          
          ;

assignment_statement : INT IDENTIFIER ASSIGNMENT expression					{debugBison(9);}
		      | IDENTIFIER  ASSIGNMENT LPAREN expression RPAREN				{debugBison(29);}
                      | STRING IDENTIFIER ASSIGNMENT expression					{debugBison(10);}
                      
                      ;

if_statement : IF_OPEN statement_list IF_CLOSE IF LPAREN expression RPAREN else_statement	{debugBison(11);}
             | IF_OPEN statement_list IF_CLOSE IF LPAREN expression RPAREN 			{debugBison(12);}
             
             ;

else_statement : ELSE IF_OPEN statement_list IF_CLOSE						{debugBison(13);}									
               ;

while_statement : WHILE_OPEN statement_list WHILE_CLOSE WHILE LPAREN expression RPAREN		{debugBison(15);}
                
                ;

print_statement : PRINT LPAREN STRING_LITERAL RPAREN						{debugBison(16);}
                
                ;

expression : term 										{debugBison(28);}
	   | expression MINUS expression							{debugBison(20);}
           | expression '+' expression								{debugBison(21);}
           | expression '*' expression								{debugBison(22);}
           | expression '/' expression								{debugBison(23);}
           | expression GREATER_THAN expression							{debugBison(24);}
           | expression LESS_THAN expression							{debugBison(25);}
           | expression EQUAL_TO expression							{debugBison(26);}
           | LPAREN expression RPAREN								{debugBison(27);}
           
           ;
           
term : 	 INTEGER_LITERAL 								{debugBison(17);}
    	| STRING_LITERAL									{debugBison(18);}
     	| IDENTIFIER										{debugBison(19);}
	;
%% 

void yyerror(const char *s) {
    fprintf(stderr, "Syntax error: %s\n", s);
}

int main(int argc, char** argv) {
	if (argc > 1) {
		FILE *fp = fopen(argv[1], "r");
		yyin = fp;
	}
	if (yyin == NULL ) {
		yyin = stdin;
	}
	
	int parseResult = yyparse();

	return EXIT_SUCCESS;
}