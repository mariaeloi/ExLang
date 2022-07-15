#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <stdbool.h>
#include "scope_stack.c"

#define MAXSIZE_STRING 100

typedef struct symbol {
    char* name; // 1.nome 4.nome
    char* type;
    struct symbol* next;
} symbol;


symbol* symbol_head;

symbol* new_symbol(char* name, char* type) {
    symbol* new = malloc(sizeof(*new));
    new->name = strdup(name);
    new->type = strdup(type);
    new->next = NULL;
    return new;
}

// symbol* free_symbol(symbol* smbl) {
//     symbol* next = smbl->next;
//     free(smbl->name);
//     free(smbl->type);
//     free(smbl);
//     return next;
// }

bool insert_symbol(char* name, char* type) {
    if(symbol_head == NULL) {
        symbol_head = new_symbol(name, type);
    } else {
        symbol* symbol_curr = symbol_head;

        bool stop = false;
        while(!stop) {
            if(strcmp(symbol_curr->name, name) == 0) {
                return false;
            }

            if(symbol_curr->next != NULL) {
                symbol_curr = symbol_curr->next;
            } else {
                symbol_curr->next = new_symbol(name, type);
                stop = true;
            }
        }
    }
    return true;
}

bool search(char* name){
    symbol* symbol_curr;
    struct Stack copy = SCOPE_STACK;

    for(int i=size_stack(&SCOPE_STACK); i >= 0; i--){
        symbol_curr = symbol_head;
        char var_scope[MAXSIZE_STRING];
        sprintf(var_scope, "%s.%s", top_stack(&copy), name);
        
        while(true) {
            if(strcmp(symbol_curr->name, var_scope) == 0){
                return true;
            }
            if(symbol_curr->next == NULL){
                break;
            }
            symbol_curr = symbol_curr->next;
        }
        pop_stack(&copy);
    }
    
    return false;
}
