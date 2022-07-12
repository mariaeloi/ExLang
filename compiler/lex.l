%{
	#include <stdio.h>
	#include <stdlib.h>
	#include <string.h>
	#include <stdarg.h>
	#include "lex.tab.h"

  	extern int yyerror (char *msg);  
%}

%option yylineno

%%
[ \t\n]                   ;
"{"                       {printf("L_K: %s\n", yytext); return (L_K);}
"}"                       {printf("R_K: %s\n", yytext); return (R_K);}
"("                   		{printf("L_P: %s\n", yytext); return (L_P);}
")"                   		{printf("R_P: %s\n", yytext); return (R_P);}
"do"                    	{printf("DO: %s\n", yytext); return(DO);}
"while"                		{printf("WHILE: %s\n", yytext); return(WHILE);}
"for"                   	{printf("FOR: %s\n", yytext); return(FOR);}
"if"                    	{printf("IF: %s\n", yytext); return(IF);}
"elsif"                		{printf("ELSIF: %s\n", yytext); return(ELSIF);}
"else"                 		{printf("ELSE: %s\n", yytext); return(ELSE);}
"return"									{printf("RETURN: %s\n", yytext); return(RETURN);}
"main"										{printf("MAIN: %s\n", yytext); return(MAIN);}
";"                   		{printf("SEMI: %s\n", yytext); return(SEMI);}
","                   		{printf("COMMA: %s\n", yytext); return(COMMA);}
"="                   		{printf("ASSIGN: %s\n", yytext); return(ASSIGN);}
"&&"											{printf("AND: %s\n", yytext); return(AND);}
"||"											{printf("OR: %s\n", yytext); return(OR);}	
"+"												{printf("PLUS: %s\n", yytext); return(PLUS);}
"-"												{printf("MINUS: %s\n", yytext); return(MINUS);}
"/"												{printf("DIVIDE: %s\n", yytext); return(DIVIDE);}
"*"												{printf("MULTY: %s\n", yytext); return(MULTY);}
"%"												{printf("PERCENT: %s\n", yytext); return(PERCENT);}
"!="											{printf("NE: %s\n", yytext); return(NE);}
"=="											{printf("EQ: %s\n", yytext); return(EQ);}
">="											{printf("GE: %s\n", yytext); return(GE);}
"<="											{printf("LE: %s\n", yytext); return(LE);}
">"												{printf("GT: %s\n", yytext); return(GT);}
"<"												{printf("LT: %s\n", yytext); return(LT);}
":"												{printf("COLON: %s\n", yytext); return(COLON);}
"string"                  {printf("STRING: %s\n", yytext); return(STRING);}
"number"                  {yylval.sValue = strdup(yytext); printf("NUMBER: %s\n", yytext); return(NUMBER);}
"char"                 		{printf("CHAR: %s\n", yytext); return(CHAR);}
"boolean"              		{printf("BOOLEAN: %s\n", yytext); return(BOOLEAN);}
"void"										{printf("VOID: %s\n", yytext); return(VOID);}
"const"										{printf("CONST: %s\n", yytext); return(CONST);}
"function"										{printf("FUNCTION: %s\n", yytext); return(FUNCTION);}
true|false               	{printf("V_BOOLEAN: %s\n", yytext); return(V_BOOLEAN);}
['].[']                  	{printf("V_CHAR: %s\n", yytext); return(V_CHAR);}
[+-]?[0-9]+(\.[0-9]+)?		{printf("V_NUMBER: %s\n", yytext); return(V_NUMBER);}
["]([^"]*)["]             {printf("V_STRING: %s\n", yytext); return(V_STRING);} //Não está funcionando direito
([a-z_]+[a-zA-Z0-9_]?)+   {yylval.sValue = strdup(yytext); printf("ID: %s\n", yytext); return(ID);}
.                     		{fprintf(stderr, "invalid character: %s\n", yytext);}
%%

#ifndef yywrap

int yywrap (void){
		return 1;
}

#endif