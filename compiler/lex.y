%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdarg.h>
#include "util/scope_stack.c"
#include "util/symbol_table.c"

int yylex(void);
int yyerror(char *s);
extern int yylineno;
extern char * yytext;
%}

%union {
	int    iValue; 	/* integer value */
	char   cValue; 	/* char value */
	char * sValue;  /* string value */
	};

%token  <sValue> ID
%token  <iValue> V_NUMBER
%token COLON FUNCTION CONST L_K R_K L_P R_P DO WHILE FOR IF ELSIF ELSE SEMI ASSIGN STRING CHAR BOOLEAN V_STRING V_CHAR V_BOOLEAN AND OR PLUS MINUS DIVIDE NE EQ GE LE GT LT VOID RETURN COMMA MAIN MULTY PERCENT

%type<sValue> NUMBER
%start prog

%% /* Inicio da segunda seção, onde colocamos as regras BNF: % PERCENT ! : COLON ! / SLASH ! * ASTERISK */

prog : {push_scope();} body				{}
    ;

body : func_main {}
    | decls func_main {}
    | funcs func_main {}
    | decls funcs func_main {} 
    ;

decls : decl SEMI                              {}
    |	decl SEMI decls					        {}
    ;

params : param                                {}
    |	param COMMA params			        {}
    ;

funcs : FUNCTION ID L_P params R_P COLON type L_K stmts R_K  { put_symbol($2, $7); }
    ;

func_main : FUNCTION MAIN {push_scope();} L_P params R_P COLON type L_K stmts R_K {pop_scope();}
    ;

func_call : ID {push_scope();} L_P termlist R_P               {pop_scope();}

stmts : stmt SEMI    				            {}
	|	stmt SEMI stmts		    		    {}
    ;

stmt :  return 								{}
    |   decl								{}
    |   assign								{}
    ;

decl : 	type idlist                    {} 
    ;

param : type ID                            {} 
    ;

type : NUMBER 								{ $$ = $1; }
    ;

idlist : ID                                 {}
    |   ID COMMA idlist                     {}
    ;

return : RETURN expr                        {}
    ;

assign : ID ASSIGN expr                     {}
    ;

expr :   term                               {}
    | ID op ID                              {}
    | func_call                             {}
    ;

op :     PLUS                                   {}
    |    MINUS                                  {}
    ;

termlist : term                                {}
    |	term COMMA termlist			        {}
    ;


term :  ID                                 {}
	| V_NUMBER 								{}
    ;

%% /* Fim da segunda seção */

int main (void) {
    SCOPE_STACK.top = (-1);
    symbol_head = NULL;

	return yyparse();
}

int yyerror (char *msg) {
	fprintf (stderr, "%d: %s at '%s'\n", yylineno, msg, yytext);
    /* printf("deu erro"); */
	return 0;
}