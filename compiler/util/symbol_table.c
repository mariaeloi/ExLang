#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <stdbool.h>


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

void insert_symbol(char* name, char* type) {
    printf("name: %s, type: %s\n", name, type);

    if(symbol_head == NULL) {
        symbol_head = new_symbol(name, type);
    } else {
        printf("--------------------------------------------%s", symbol_head->name);
        symbol* symbol_curr = symbol_head;

        bool stop = false;
        while(!stop) {
            printf("### symbol_curr: %s\n", symbol_curr->name);
            if(strcmp(symbol_curr->name, name) == 0) {
                printf("A variável '%s' já foi declarada anteriormente\n", name);
                return;
            }

            if(symbol_curr->next != NULL) {
                printf("### next: %s\n", symbol_curr->next->name);
                symbol_curr = symbol_curr->next;
            } else {
                symbol_curr->next = new_symbol(name, type);
                printf("### next: %s\n", symbol_curr->next->name);
                stop = true;
            }
        }
    }
}

bool search(char* name){
    symbol* symbol_curr = symbol_head;
    
    bool stop = false;
    while(!stop){
        if(strcmp(symbol_curr->name, name) == 0){
            return true;
        }
        if(symbol_curr->next == NULL){
            break;
        }
        symbol_curr = symbol_curr->next;
    }
    return false;
}
