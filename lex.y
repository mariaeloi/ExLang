%{
#include  <stdio.h>

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
%token  <iValue> NUMBER
%token COLON FUNCTION CONST L_K R_K L_P R_P DO WHILE FOR IF ELSIF ELSE SEMI ASSIGN STRING CHAR BOOLEAN V_STRING V_NUMBER V_CHAR V_BOOLEAN AND OR PLUS MINUS DIVIDE NE EQ GE LE GT LT VOID RETURN COMMA MAIN MULTY PERCENT

%start prog

%% /* Inicio da segunda seção, onde colocamos as regras BNF: % PERCENT ! : COLON ! / SLASH ! * ASTERISK */

prog : decls funcs func_main				{}

decls : decl                                {}
    |	decl decls					        {}
    ;
funcs : FUNCTION ID L_P decl R_P COLON type L_K stmts R_K   {}
    ;

func_main : FUNCTION MAIN L_P decl R_P COLON type L_K stmts R_K {}
    ;

stmts : stmt     				            {}
	|	stmt SEMI stmts		    		    {}
    ;

stmt :  return 								{}
    |   decls								{}
    |   assign								{}
    ;

decl : 	type idlist SEMI                    {} 
    ;

type : NUMBER 								{}
    ;

idlist : ID                                 {}
    |   ID COMMA idlist                     {}
    ;

return : RETURN expr                        {}
    ;

assign : ID ASSIGN expr                     {}
    ;

expr :   ID                                 {}
	| V_NUMBER 								{}
    ;

%% /* Fim da segunda seção */

int main (void) {
	return yyparse();
}

int yyerror (char *msg) {
	fprintf (stderr, "%d: %s at '%s'\n", yylineno, msg, yytext);
    /* printf("deu erro"); */
	return 0;
}