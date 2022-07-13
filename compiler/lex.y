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

%token<sValue> ID V_STRING V_BOOLEAN NUMBER STRING CHAR BOOLEAN
%token<cValue> V_CHAR
%token<iValue> V_NUMBER
%token CONST VOID FUNCTION MAIN
%token AND OR
%token IF ELSIF ELSE DO WHILE FOR 
%token ASSIGN PLUS MINUS DIVIDE MULTY PERCENT
%token NE EQ GE LE GT LT
%token RETURN 
%token L_K R_K L_P R_P COLON SEMI COMMA

%type<sValue> type idlist
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

funcs : FUNCTION ID L_P params R_P COLON type L_K stmts R_K  {}
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

decl : 	type idlist {
            char var_scope[0];
            sprintf(var_scope, "%d.%s", top_scope(), $2);
            insert_symbol(var_scope, $1); 
        } 
    ;

param : type ID                            {} 
    ;

type : NUMBER 								{ $$ = $1; }
    ;

idlist : ID                                 { $$ = $1; }
    |   ID COMMA idlist                     { $$ = $3; } // TODO corrigir pois só está pegando o último id
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
	return 0;
}