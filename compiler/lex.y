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

bool has_return = false;
char* type_return;

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
	char * sValue;  /* string value */

    struct metaData* metValue;
    struct metaDataPaF* metPaFValue;
};

%token<sValue> ID V_STRING V_BOOLEAN V_NUMBER V_CHAR
%token<cValue> 
%token<dValue> 
%token CONST VOID FUNCTION MAIN
%token AND OR
%token NUMBER STRING CHAR BOOLEAN
%token IF ELSIF ELSE DO WHILE FOR 
%token ASSIGN PLUS MINUS DIVIDE MULTY PERCENT EXP
%token NE EQ GE LE GT LT
%token RETURN EXL 
%token L_K R_K L_P R_P COLON SEMI COMMA
%token PRINT

%type<sValue> idlist decl decls body func_main funcs  print_param print stmt stmts return assign op
%type<metValue> type result_type
%type<metPaFValue> param term expr params
%start prog

%% /* Inicio da segunda seção, onde colocamos as regras BNF: % PERCENT ! : COLON ! / SLASH ! * ASTERISK */

prog : EXL ID {
            push_stack(&SCOPE_STACK, "0");} 
        body {create_file($2, $4);}
    ;

body : func_main {}
    | decls func_main {
        $$ = concate(2, $1, $2);}
    | funcs func_main {}
    | decls funcs func_main {} 
    ;

decls : decl SEMI                              {
    $$ = concate(2, $1, ";\n");}
    |	decl SEMI decls					       {
        $$ = concate(3, $1, ";\n", $3);}
    ;


funcs : FUNCTION ID {push_stack(&SCOPE_STACK, $2);} L_P params {
    char var_scope[1];
    sprintf(var_scope, "%s.%s", top_stack(&SCOPE_STACK), $5->id);
    insert_symbol(var_scope, $5->type);
} R_P COLON result_type {
    type_return = $9->type;
} L_K stmts R_K  {
    if(!has_return){
        yyerror("ERRO DE RETORNO DA FUNCAO");
        exit(0);
    } else {
        has_return = false;
    }
    pop_stack(&SCOPE_STACK);
}
    ;

func_main : FUNCTION MAIN {push_stack(&SCOPE_STACK, "main");} L_P params {
        char var_scope[MAXSIZE_STRING];
        sprintf(var_scope, "%s.%s", top_stack(&SCOPE_STACK), $5->id);
        insert_symbol(var_scope, $5->type);
} R_P COLON NUMBER {
    type_return = "number";
} L_K stmts R_K {
    if(!has_return){
        yyerror("ERRO DE RETORNO DO MAIN");
        exit(0);
    } else {
        has_return = false;
    }
    pop_stack(&SCOPE_STACK);
    $$ = concate(5, "double main", "(", ")\n{\n", $12, "}");
    //$$ = "123";
}
    ;

func_call : ID L_P termlist R_P               {}

stmts : stmt SEMI    				        {
    $$ = concate(3, "\t",$1, ";\n");}
	|	stmt SEMI stmts		    		    { 
        $$ = concate(4, "\t", $1, ";\n", $3)}
    ;

stmt :                                      {}
    |   return 								{$$ = $1;}
    |   decl								{}
    |   assign								{$$ = $1;}
    |   print                               {$$ = $1;}
    ;

decl : 	type idlist {
            char* concate_return;
            if(idlist_quantity == 0){
                char var_scope[MAXSIZE_STRING];
                sprintf(var_scope, "%s.%s", top_stack(&SCOPE_STACK), multi_idlist[idlist_quantity]);
                if(!insert_symbol(var_scope, $1->type)) {
                    yyerror("IDENTIFICADOR JA FOI DECLARADO NO ESCOPO!");
                    exit(0);
                } 
                multi_idlist[idlist_quantity] = NULL;
                idlist_quantity--;
            } else {
                char var_scope[MAXSIZE_STRING];
                for(int i = idlist_quantity; i >= 0; i--){
                    sprintf(var_scope, "%s.%s", top_stack(&SCOPE_STACK), multi_idlist[i]);
                    if(!insert_symbol(var_scope, $1->type)) {
                        yyerror("IDENTIFICADOR JA FOI DECLARADO NO ESCOPO!");
                        exit(0);
                    }
                    multi_idlist[i] = NULL;
                    // idlist_quantity--;
                }
                idlist_quantity = -1;
            }
            concate_return = concate(3, $1->type_c, " ", $2);
            $$ = concate_return;
        } 
    ;

params : param                                {$$ = $1;}
    |	param COMMA params			        {

        //params : param                                {$$ = concate(2, $1->type_c, $1->id);}
        // |	param COMMA params			        {$$ = concate(4, $1->type_c, $1->id, ",", $3);}
        // ;
    }

    ;

param : {}
| type ID {
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
    }
    ;

return : RETURN expr {
    if(strcmp(type_return, "void") == 0){
        yyerror("FUNCAO NAO ESPERA RETORNO!");
        exit(0);
    }
    if(strcmp($2->type, type_return) == 0){
        has_return = true;
    }
    $$ = concate(2, "return ", $2->id);
    //has_return = true;
    //$$ = "return 0";
}
    ;

assign : ID ASSIGN expr   {
    symbol* symbol = search($1);
    if(symbol == NULL){
        yyerror("VARIAVEL NAO EXISTE NO ESCOPO DO BLOCO");
        exit(0);
    } else if (strcmp(symbol->type, $3->type) != 0){
        yyerror("VARIAVEL NAO COMPATIVEL COM A ATRIBUICAO");
        exit(0);
    }
    $$ = concate(3, $1, " = ", $3->id);
    //char* temp = concate(3, $1, " = ", $3->id);
    //printf("# %s\n", temp);
    //$$ = temp;
}
    ;

expr :   term                               {$$ = $1;}
    |  expr op term                            {
        printf("# %s | %s\n", $1->id, $3->id);
        if(strcmp($1->type, $3->type) == 0){
            char* temp;
            if($2 == "**"){
                temp = concate(5, "pow(",$1->id, ", ", $3->id, ")  ");
            } else {
                temp = concate(3, $1->id, $2, $3->id);
            }
            struct metaDataPaF* metadata = (struct metaDataPaF*) malloc(sizeof(struct metaDataPaF));
            metadata->id = temp;
            metadata->type = $1->type;
            metadata->type_c = $1->type_c;
            $$ = metadata;
        } else {
            yyerror("TERMOS NAO COMPATIVEIS!");
            exit(0);
        }
    }
    | func_call                             {}
    ;

op :     PLUS                                   {$$ = " + ";}
    |    MINUS                                  {$$ = " - ";}
    |    DIVIDE                                 {$$ = " / ";}
    |    MULTY                                  {$$ = " * ";}
    |    PERCENT                                {$$ = " % ";}
    |    EXP                                    {$$ = "**";}
    ;

termlist : term                 {}
    |	term COMMA termlist     {}
    ;


term :  ID {
        symbol* symbol = search($1);
        if(symbol == NULL){
            yyerror("IDENTIFICADOR NAO EXISTE NO ESCOPO!");
            exit(0);
        } else {
            struct metaDataPaF* metadata = (struct metaDataPaF*) malloc(sizeof(struct metaDataPaF));
            metadata->id = $1;
            metadata->type = symbol->type;
            if(symbol->type == "number"){
                metadata->type_c = "double";
            } else if(symbol->type == "string"){
                metadata->type_c = "char*";
            } else if(symbol->type == "boolean"){
                metadata->type_c = "bool";
            } else if(symbol->type == "char"){
                metadata->type_c = "char";
            }
            $$ = metadata;
        }
    }
	| V_NUMBER {
        struct metaDataPaF* metadata = (struct metaDataPaF*) malloc(sizeof(struct metaDataPaF));
        metadata->id = $1;
        metadata->type = "number";
        metadata->type_c = "double";
        // printf("----> V_NUMBER:  %s\n", $1);
        $$ = metadata;
    }
    | V_STRING                      {
        struct metaDataPaF* metadata = (struct metaDataPaF*) malloc(sizeof(struct metaDataPaF));
        metadata->id = $1;
        metadata->type = "string";
        metadata->type_c = "char*";
        // printf("----> V_STRING:  %s\n", metadata->id);
        $$ = metadata;
    }
    ;

print_param : expr  {
    char* temp = concate(2, "\"%f\", ", $1->id);
    printf("temp: %s\n", temp);
    $$ = temp;
    //$$ = "x**2 - y + c";
    }
    ;

print : PRINT L_P print_param R_P      {
    $$ = concate(3, "printf(", $3, " ) ");
    }
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