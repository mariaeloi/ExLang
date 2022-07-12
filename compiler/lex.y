%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdarg.h>

#define MAXSIZE 5

int yylex(void);
int yyerror(char *s);
extern int yylineno;
extern char * yytext;

struct data {
    char* type;
    char* value;
};

struct scope_queue {
    int top;
    char* queue[MAXSIZE];
};

struct scope_queue SQ;

void push(char* scope);
int  pop(void);
int top_index(void);
char* top_name(void);

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

prog : {push("global");} decls funcs func_main				{}

decls : decl SEMI                              {}
    |	decl SEMI decls					        {}
    ;

params : param                                {}
    |	param COMMA params			        {}
    ;

funcs : FUNCTION ID L_P params R_P COLON type L_K stmts R_K  { }
    ;

func_main : FUNCTION MAIN {push("main");} L_P params R_P COLON type L_K stmts R_K { printf("result: (%d) = %s\n", top_index(), top_name()); }
    ;

func_call : ID {push($1);} L_P termlist R_P               {printf("result: (%d) = %s\n", top_index(), top_name()); pop();}

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

type : NUMBER 								{}
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
    SQ.top = (-1);
	return yyparse();
}

int yyerror (char *msg) {
	fprintf (stderr, "%d: %s at '%s'\n", yylineno, msg, yytext);
    /* printf("deu erro"); */
	return 0;
}

void push(char* scope)
{
    char value[20];

    if (SQ.top == (MAXSIZE - 1))
    {
        printf ("Pilha Cheia!\n");
        return;
    }
    else
    {
        SQ.top++;
        SQ.queue[SQ.top] = scope;
    }
    return;
}
/* Função para excluir um elemento da pilha */
int pop()
{
    int num;
    if (SQ.top == - 1)
    {
        printf("Pilha Vazia!\n");
        return(SQ.top);
    }
    else
    {
        num = SQ.top;
        printf ("Elemento a ser retirado eh: = %s\n", SQ.queue[SQ.top]);
        SQ.top--;
    }
    return(num);
}
/* Retornar o topo da pilha */
int top_index()
{
    return SQ.top;
}
/* Retornar o valor do topo da pilha */
char* top_name()
{
    return SQ.queue[SQ.top];
}