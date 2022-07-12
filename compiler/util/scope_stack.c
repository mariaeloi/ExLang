#include <stdio.h>
#define MAXSIZE 32

struct scope_stack {
    int top;
    int stack[MAXSIZE];
};

struct scope_stack SCOPE_STACK;

void push_scope() {
    if (SCOPE_STACK.top == (MAXSIZE - 1)) {
        printf ("SCOPE_STACK cheia\n");
        return;
    } else {
        SCOPE_STACK.top++;
        SCOPE_STACK.stack[SCOPE_STACK.top] = SCOPE_STACK.top;
    }
    return;
};

int pop_scope() {
    int num;
    if (SCOPE_STACK.top == - 1) {
        printf("SCOPE_STACK vazia\n");
        return(SCOPE_STACK.top);
    } else {
        num = SCOPE_STACK.top;
        printf("SCOPE_STACK.pop(): %d\n", SCOPE_STACK.stack[SCOPE_STACK.top]);
        SCOPE_STACK.top--;
    }
    return(num);
}

int top_scope() {
    printf("SCOPE_STACK.top(): %d\n", SCOPE_STACK.stack[SCOPE_STACK.top]);
    return SCOPE_STACK.top;
}