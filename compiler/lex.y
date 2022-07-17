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

int count_selection = 0;

%}

%union {
	char * sValue;  /* string value */

    struct metaData* metValue;
    struct metaDataPaF* metPaFValue;
};

%token<sValue> ID V_STRING V_BOOLEAN V_NUMBER V_CHAR
%token CONST VOID FUNCTION MAIN
%token AND OR
%token NUMBER STRING CHAR BOOLEAN
%token IF ELSIF ELSE DO WHILE FOR 
%token ASSIGN PLUS MINUS DIVIDE MULTY PERCENT EXP
%token NE EQ GE LE GT LT
%token RETURN EXL 
%token L_K R_K L_P R_P COLON SEMI COMMA
%token PRINT READ

%type<sValue> idlist decl decls body func_main funcs print_param print stmt stmts return assign op params read compare_op if while logic_op
%type<metValue> type result_type
%type<metPaFValue> param term expr 
%start prog

%% /* Inicio da segunda seção, onde colocamos as regras BNF: % PERCENT ! : COLON ! / SLASH ! * ASTERISK */

prog : EXL ID {
            push_stack(&SCOPE_STACK, "0");} 
        body {create_file($2, $4); free($4);}
    ;

body : func_main { $$ = $1; }
    | decls func_main {$$ = concate(2, $1, $2); free($1); free($2);}
    | funcs func_main { }
    | decls funcs func_main {
        $$ = concate(3, $1, $2, $3);
        free($1); free($2); free($3);
    } 
    ;

decls : decl SEMI                              {$$ = concate(2, $1, ";\n");}
    |	decl SEMI decls					       {$$ = concate(3, $1, ";\n", $3); free($3);} //
    ;


funcs : FUNCTION ID {push_stack(&SCOPE_STACK, $2);} L_P params R_P COLON result_type {
    type_return = $8->type;
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

func_main : FUNCTION MAIN {push_stack(&SCOPE_STACK, "main"); } L_P params R_P COLON NUMBER {
    type_return = "number";
} L_K stmts R_K {
    if(!has_return){
        yyerror("ERRO DE RETORNO DO MAIN");
        free($5);
        free($11);
        exit(0);
    } else {
        has_return = false;
    }
    pop_stack(&SCOPE_STACK);
    $$ = concate(6, "double main", "(", $5, ")\n{\n", $11, "}\n");
    free($5);
    free($11);
}
    ;

func_call : ID L_P termlist R_P               {}

stmts : stmt SEMI    				        {$$ = concate(3, "\t",$1, ";\n"); free($1);}
	|	stmt SEMI stmts		    		    {$$ = concate(4, "\t", $1, ";\n", $3); free($1); free($3);}
    ;

stmt :                                      {}
    |   return 								{$$ = $1;}
    |   decl								{$$ = $1;}
    |   assign								{$$ = $1;}
    |   print                               {$$ = $1;}
    |   read                                {$$ = $1;}
    |   if                                  {$$ = $1;}
    |   while                               {$$ = $1;}
    ;

decl : 	type idlist {
            char* concate_return;
            if(idlist_quantity == 0){
                char var_scope[MAXSIZE_STRING];
                sprintf(var_scope, "%s.%s", top_stack(&SCOPE_STACK), multi_idlist[idlist_quantity]);
                if(!insert_symbol(var_scope, $1->type)) {
                    char msg_erro[255];
                    sprintf(msg_erro, "IDENTIFICADOR \'%s\' JA FOI DECLARADO NO ESCOPO! (escopo: %s)", multi_idlist[idlist_quantity], top_stack(&SCOPE_STACK));
                    yyerror(msg_erro);
                    free($1);
                    free($2);
                    exit(0);
                } 
                multi_idlist[idlist_quantity] = NULL;
                idlist_quantity--;
            } else {
                char var_scope[MAXSIZE_STRING];
                for(int i = idlist_quantity; i >= 0; i--){
                    sprintf(var_scope, "%s.%s", top_stack(&SCOPE_STACK), multi_idlist[i]);
                    if(!insert_symbol(var_scope, $1->type)) {
                        char msg_erro[255];
                        sprintf(msg_erro, "IDENTIFICADOR \'%s\' JA FOI DECLARADO NO ESCOPO! (escopo: %s)", multi_idlist[i], top_stack(&SCOPE_STACK));
                        yyerror(msg_erro);
                        free($1);
                        free($2);
                        exit(0);
                    }
                    multi_idlist[i] = NULL;
                    // idlist_quantity--;
                }
                idlist_quantity = -1;
            }
            concate_return = concate(3, $1->type_c, "  ", $2);
            $$ = concate_return;
            free($1);
            free($2);
        } 
    ;

params : param  {
        if($1->id == "  "){
            $$ = "  ";
        } else {
            char var_scope[MAXSIZE_STRING];
            sprintf(var_scope, "%s.%s", top_stack(&SCOPE_STACK), $1->id);
            insert_symbol(var_scope, $1->type);
            $$ = concate(3, $1->type_c, "  ", $1->id);
        }
    }
    |	param COMMA params			        {
    char var_scope[MAXSIZE_STRING];
    sprintf(var_scope, "%s.%s", top_stack(&SCOPE_STACK), $1->id);

    if(!insert_symbol(var_scope, $1->type)) {
        yyerror("NOME DE VARIAVEIS IGUAIS NOS PARAMETROS DA FUNCAO");
        exit(0);
    }
    $$ = concate(5, $1->type_c, "   ", $1->id, " , ", $3);
    }

    ;

param : {
    struct metaDataPaF* metadata = (struct metaDataPaF*) malloc(sizeof(struct metaDataPaF));
    metadata->id = "  ";
    $$ = metadata;}
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
    $$ = concate(3, $1, " , ", $3);
    }
    ;

return : RETURN expr {
    if(strcmp(type_return, "void") == 0){
        yyerror("FUNCAO NAO ESPERA RETORNO!");
        free($2);
        exit(0);
    }
    if(strcmp($2->type, type_return) == 0){
        has_return = true;
    }
    $$ = concate(2, "return ", $2->id);
    free($2);
}
    ;

assign : ID ASSIGN expr   {
    symbol* symbol = search($1);
    if(symbol == NULL){
        yyerror("VARIAVEL NAO EXISTE NO ESCOPO DO BLOCO");
        free($3);
        exit(0);
    } else if (strcmp(symbol->type, $3->type) != 0){
        yyerror("VARIAVEL NAO COMPATIVEL COM A ATRIBUICAO");
        free($3);
        exit(0);
    }
    $$ = concate(3, $1, " = ", $3->id);
    free($3);
}
    ;

expr :   term                               {$$ = $1;}
    |  expr op term                            {
        if(strcmp($1->type, $3->type) == 0){
            char* temp;
            if($2 == "**"){
                temp = concate(5, "pow(",$1->id, ", ", $3->id, ")  ");
            } else {
                temp = concate(3, $1->id, $2, $3->id);
            }
            free($3);

            struct metaDataPaF* metadata = (struct metaDataPaF*) malloc(sizeof(struct metaDataPaF));
            metadata->id = temp;
            metadata->type = $1->type;
            metadata->type_c = $1->type_c;
            $$ = metadata;
        } else {
            yyerror("TERMOS NAO COMPATIVEIS!");
            free($1);
            free($3);
            exit(0);
        }
    }
    |   func_call                             {}
    |   expr compare_op term                  {
        // TODO realizar verificações
        char *temp = concate(3, $1->id, $2, $3->id);
        struct metaDataPaF* metadata = (struct metaDataPaF*) malloc(sizeof(struct metaDataPaF));
        metadata->id = temp;
        metadata->type = "boolean";
        metadata->type_c = "bool";
        $$ = metadata;
    }
    |   expr logic_op term                  {
        // TODO realizar verificações
        char *temp = concate(3, $1->id, $2, $3->id);
        struct metaDataPaF* metadata = (struct metaDataPaF*) malloc(sizeof(struct metaDataPaF));
        metadata->id = temp;
        metadata->type = "boolean";
        metadata->type_c = "bool";
        $$ = metadata;
    }
    ;

op :     PLUS                                   {$$ = " + ";}
    |    MINUS                                  {$$ = " - ";}
    |    DIVIDE                                 {$$ = " / ";}
    |    MULTY                                  {$$ = " * ";}
    |    PERCENT                                {$$ = " % ";}
    |    EXP                                    {$$ = "**";}
    ;

compare_op: EQ                  {$$ = " == ";}
    |   NE                      {$$ = " != ";}
    |   LE                      {$$ = " <= ";}
    |   LT                      {$$ = " < ";}
    |   GE                      {$$ = " >= ";}
    |   GT                      {$$ = " > ";}
    ;

logic_op:   AND                 {$$ = " && ";}
    |   OR                      {$$ = " || ";}
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
            if(strcmp(symbol->type, "number") == 0){
                metadata->type_c = "double";
            } else if(strcmp(symbol->type, "string") == 0){
                metadata->type_c = "char*";
            } else if(strcmp(symbol->type, "boolean") == 0){
                metadata->type_c = "bool";
            } else if(strcmp(symbol->type, "char") == 0){
                metadata->type_c = "char";
            } else {
                yyerror("TIPO INVALIDO");
                exit(0);
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
    $$ = temp;
    free($1); //
    }
    ;

print : PRINT L_P print_param R_P      {
    $$ = concate(3, "printf(", $3, " ) ");
    free($3);
    }
    ;

read : READ L_P ID R_P                  {
    symbol* symbol = search($3);
    if(symbol == NULL){
        yyerror("VARIAVEL NAO EXISTE NO ESCOPO DO BLOCO");
        free($3);
        exit(0);
    } else {
        char *temp;
        if(strcmp(symbol->type, "number") == 0){
            printf("READ: number\n");
            temp = concate(3, "scanf(\"%lf\", &", $3, " ) ");
        } 
        else if(strcmp(symbol->type, "string") == 0){
            printf("READ: string\n");
            temp = concate(3, "scanf(\"%s\", &", $3, " ) ");
        } else if(strcmp(symbol->type, "char") == 0){
            printf("READ: char\n");
            temp = concate(3, "scanf(\"%c\", &", $3, " ) ");
        } else {
            yyerror("BOOLEAN NAO EH COMPATIVEL COM READ");
            exit(0);
        }
        $$ = temp;
    }
}
    ;

if : IF L_P expr {
    if(strcmp($3->type, "boolean") != 0){
        yyerror("A CONDICAO DE UM IF DE DEVE SER (OU RESULTAR EM) UM BOOLEAN");
        free($3);
        exit(0);
    }
    printf("expr IF: %s\n", $3->id);
} R_P L_K {
    count_selection++;
    char var_scope[MAXSIZE_STRING];
    sprintf(var_scope, "%s_%s%d", top_stack(&SCOPE_STACK), "if", count_selection);
    printf("id IF: %s\n", var_scope);
    push_stack(&SCOPE_STACK, var_scope);
} stmts R_K {
    char var_skip[MAXSIZE_STRING];
    sprintf(var_skip, "%s_skip", top_stack(&SCOPE_STACK));
    $$ = concate(9, "if (!(", $3->id, ")) goto ", var_skip, ";\n\t{\n", $8, "\t}\n\t", var_skip, ":\n");
    pop_stack(&SCOPE_STACK);
    printf("top: %s\n", top_stack(&SCOPE_STACK));
    free($3);
    free($8);
}
    ;

while : WHILE L_P expr {
    if(strcmp($3->type, "boolean") != 0){
        yyerror("A CONDICAO DE UM WHILE DE DEVE SER (OU RESULTAR EM) UM BOOLEAN");
        free($3);
        exit(0);
    }
    printf("expr WHILE: %s\n", $3->id);
} R_P L_K {
    count_selection++;
    char var_scope[MAXSIZE_STRING];
    sprintf(var_scope, "%s_%s%d", top_stack(&SCOPE_STACK), "while", count_selection);
    printf("id WHILE: %s\n", var_scope);
    push_stack(&SCOPE_STACK, var_scope);
} stmts R_K {
    char var_skip[MAXSIZE_STRING];
    sprintf(var_skip, "%s_skip", top_stack(&SCOPE_STACK));
    $$ = concate(12, top_stack(&SCOPE_STACK), ":\n\tif (!(", $3->id, ")) goto ", var_skip, ";\n\t{\n", $8, "\t}\n\tgoto ", top_stack(&SCOPE_STACK), ";\n\t", var_skip, ":\n");
    pop_stack(&SCOPE_STACK);
    free($3);
    free($8);
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