#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <stdbool.h>


typedef struct {
    char* name; // 1.nome 4.nome
    char* type;
    symbol* next;
} symbol;

symbol* symbol_head;

void put_symbol(char* name, char* type) {
    printf("name: %s, type: %s", name, type);
    if(symbol_head == NULL) {
        symbol symbol_curr;
        symbol_curr.name = name;
        symbol_curr.type = type;
        // symbol_curr.next = NULL;

        symbol_head = &symbol_curr;
    } else {
        printf("symbol: %s", symbol_head->name);
    }
}
