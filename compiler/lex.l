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
"{"                       {return (L_K);}
"}"                       {return (R_K);}
"("                   		{return (L_P);}
")"                   		{return (R_P);}
"do"                    	{return(DO);}
"while"                		{return(WHILE);}
"for"                   	{return(FOR);}
"if"                    	{return(IF);}
"elsif"                		{return(ELSIF);}
"else"                 		{return(ELSE);}
"return"					{return(RETURN);}
"main"						{return(MAIN);}
";"                   		{return(SEMI);}
","                   		{return(COMMA);}
"="                   		{return(ASSIGN);}
"&&"						{return(AND);}
"||"						{return(OR);}	
"+"							{return(PLUS);}
"-"							{return(MINUS);}
"/"							{return(DIVIDE);}
"*"							{return(MULTY);}
"%"							{return(PERCENT);}
"**"						{return(EXP);}
"!="						{return(NE);}
"=="						{return(EQ);}
">="						{return(GE);}
"<="						{return(LE);}
">"							{return(GT);}
"<"							{return(LT);}
":"							{return(COLON);}
"string"                    {return(STRING);}
"number"                    {return(NUMBER);}
"char"                 		{return(CHAR);}
"boolean"              		{return(BOOLEAN);}
"void"						{return(VOID);}
"const"						{return(CONST);}
"function"					{return(FUNCTION);}
"print"						{return(PRINT);}
"ExL"						{return(EXL);}
true|false               	{return(V_BOOLEAN);}
['].[']                  	{return(V_CHAR);}
[+-]?[0-9]+(\.[0-9]+)?		{return(V_NUMBER);}
["]([A-Za-z0-9+-=*/: ])+["]         {yylval.sValue = strdup(yytext); return(V_STRING);}
([a-z_]+[a-zA-Z0-9_]?)+     {yylval.sValue = strdup(yytext); return(ID);}
.                     		{fprintf(stderr, "invalid character: %s\n", yytext);}
%%

#ifndef yywrap

int yywrap (void){
		return 1;
}

#endif