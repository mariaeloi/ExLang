#include <stdio.h>
#define MAXSIZE 32

struct Stack {
    int top;
    char* stack[MAXSIZE];
};

struct Stack SCOPE_STACK;

void push_stack(struct Stack* stack, char* scope) {
    if (stack->top == (MAXSIZE - 1)) {
        printf ("SCOPE_STACK cheia\n");
        return;
    } else {
        stack->top++;
        stack->stack[stack->top] = scope;
    }
    return;
};

void pop_stack(struct Stack* stack) {
    if (stack->top == - 1) {
        printf("SCOPE_STACK vazia\n");
    } else {
        //printf("SCOPE_STACK.pop(): %s\n", SCOPE_STACK.stack[SCOPE_STACK.top]);
        stack->top--;
    }
}

char* top_stack(struct Stack* stack) {
    // printf("SCOPE_STACK.top(): %s\n", stack->stack[SCOPE_STACK.top]);
    // return SCOPE_STACK.top;
    return stack->stack[stack->top];
}

int size_stack(struct Stack* stack) {
    return stack->top;
}

char* top_stack_k(struct Stack* stack, int k) {
    if(k > stack->top) {
        //printf("null\n");
        return NULL;
    }
    //printf("top k %s, k %d\n", stack->stack[k], k);
    // int index = stack->top
    return stack->stack[k];
}