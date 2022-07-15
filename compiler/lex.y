%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdarg.h>
#include "util/symbol_table.c"
#include "util/generator_c.c"

int yylex(void);
int yyerror(char *s);
extern int yylineno;
extern char * yytext;

int idlist_quantity = -1;
char* multi_idlist[10];

struct metaData {
    char* type;
    char* type_c;
};

struct metaDataPaF {
    char* id;
    char* type;
    char* type_c;
};

%}

%union {
	int    iValue; 	/* integer value */
	char   cValue; 	/* char value */
	char * sValue;  /* string value */

    struct metaData* metValue;
    struct metaDataPaF* metPaFValue;
};

%token<sValue> ID V_STRING V_BOOLEAN 
%token<cValue> V_CHAR
%token<iValue> V_NUMBER
%token CONST VOID FUNCTION MAIN
%token AND OR
%token NUMBER STRING CHAR BOOLEAN
%token IF ELSIF ELSE DO WHILE FOR 
%token ASSIGN PLUS MINUS DIVIDE MULTY PERCENT EXP
%token NE EQ GE LE GT LT
%token RETURN EXL 
%token L_K R_K L_P R_P COLON SEMI COMMA
%token PRINT

%type<sValue> idlist
%type<metValue> type result_type
%type<metPaFValue> param params
%start prog

%% /* Inicio da segunda seção, onde colocamos as regras BNF: % PERCENT ! : COLON ! / SLASH ! * ASTERISK */

prog : EXL ID {
            push_stack(&SCOPE_STACK, "0");} 
        body {create_file($2, "nada ainda");}
    ;

body : func_main {}
    | decls func_main {}
    | funcs func_main {}
    | decls funcs func_main {} 
    ;

decls : decl SEMI                              {}
    |	decl SEMI decls					        {}
    ;


funcs : FUNCTION ID {push_stack(&SCOPE_STACK, $2);} L_P params {
    char var_scope[1];
    sprintf(var_scope, "%s.%s", top_stack(&SCOPE_STACK), $5->id);
    insert_symbol(var_scope, $5->type);
} R_P COLON result_type L_K stmts R_K  {pop_stack(&SCOPE_STACK);}
    ;

func_main : FUNCTION MAIN {push_stack(&SCOPE_STACK, "main");} L_P params {
        char var_scope[1];
        sprintf(var_scope, "%s.%s", top_stack(&SCOPE_STACK), $5->id);
        insert_symbol(var_scope, $5->type);
} R_P COLON type L_K stmts R_K {pop_stack(&SCOPE_STACK);}
    ;

func_call : ID L_P termlist R_P               {}

stmts : stmt SEMI    				            {}
	|	stmt SEMI stmts		    		    {}
    ;

stmt :  return 								{}
    |   decl								{}
    |   assign								{}
    |   print                               {}
    ;

decl : 	type idlist {
            if(idlist_quantity == 0){
                char var_scope[MAXSIZE_STRING];
                insert_symbol(var_scope, $1->type); 
                multi_idlist[idlist_quantity] = NULL;
                idlist_quantity--;
            } else {
                char var_scope[MAXSIZE_STRING];
                for(int i = idlist_quantity; i >= 0; i--){
                    sprintf(var_scope, "%s.%s", top_stack(&SCOPE_STACK), multi_idlist[i]);
                    insert_symbol(var_scope, $1->type); 
                    multi_idlist[idlist_quantity] = NULL;
                    idlist_quantity--;
                }
            }
        } 
    ;

params : param                                {$$ = $1;}
    |	param COMMA params			        {}
    ;

param : type ID {
    struct metaDataPaF* metadata = (struct metaDataPaF*) malloc(sizeof(struct metaDataPaF));
    metadata->id = $2;
    metadata->type = $1->type;
    metadata->type_c = $1->type_c;
    $$ = metadata;
} 
    ;

result_type : type { $$ = $1;}
    | VOID {
        struct metaData* metadata = (struct metaData*) malloc(sizeof(struct metaData));
        metadata->type = "void";
        metadata->type_c = "void";
        $$ = metadata;}

type : NUMBER { 
        struct metaData* metadata = (struct metaData*) malloc(sizeof(struct metaData));
        metadata->type = "number";
        metadata->type_c = "double";
        $$ = metadata;
        }
    | STRING                            {
        struct metaData* metadata = (struct metaData*) malloc(sizeof(struct metaData));
        metadata->type = "string";
        metadata->type_c = "char*";
        $$ = metadata;
    }
    | CHAR                              {
        struct metaData* metadata = (struct metaData*) malloc(sizeof(struct metaData));
        metadata->type = "char";
        metadata->type_c = "char";
        $$ = metadata;
    }
    | BOOLEAN                           {
        struct metaData* metadata = (struct metaData*) malloc(sizeof(struct metaData));
        metadata->type = "boolean";
        metadata->type_c = "bool";
        $$ = metadata;
    }
    ;

idlist : ID                                 { 
    idlist_quantity++; 
    multi_idlist[idlist_quantity] = $1;
    $$ = $1;
    }
    |   ID COMMA idlist                     { 
    idlist_quantity++;
    multi_idlist[idlist_quantity] = $1;
    $$ = concate(3, $1, ",", $3);
    } // TODO corrigir pois só está pegando o último id
    ;

return : RETURN expr                        {}
    ;

assign : ID ASSIGN expr                     {}
    ;

expr :   term                               {}
    | term op expr                              {}
    | func_call                             {}
    ;

op :     PLUS                                   {}
    |    MINUS                                  {}
    |    DIVIDE                                 {}
    |    MULTY                                  {}
    |    PERCENT                                {}
    |    EXP                                    {}
    ;

termlist : term                                {}
    |	term COMMA termlist			        {}
    ;


term :  ID {
            if(!search($1)){
                printf("->> %s <<-", $1);
                yyerror("IDENTIFICADOR NAO EXISTE NO ESCOPO!");
                exit(0);
            }
            
    }
	| V_NUMBER 							   {}
    ;

print_param : expr                                {}
    ;

print : PRINT L_P print_param R_P      {}
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