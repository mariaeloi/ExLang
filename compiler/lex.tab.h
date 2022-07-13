
/* A Bison parser, made by GNU Bison 2.4.1.  */

/* Skeleton interface for Bison's Yacc-like parsers in C
   
      Copyright (C) 1984, 1989, 1990, 2000, 2001, 2002, 2003, 2004, 2005, 2006
   Free Software Foundation, Inc.
   
   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.
   
   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.
   
   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.
   
   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */


/* Tokens.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
   /* Put the tokens into the symbol table, so that GDB and other debuggers
      know about them.  */
   enum yytokentype {
     ID = 258,
     V_STRING = 259,
     V_BOOLEAN = 260,
     NUMBER = 261,
     STRING = 262,
     CHAR = 263,
     BOOLEAN = 264,
     V_CHAR = 265,
     V_NUMBER = 266,
     CONST = 267,
     VOID = 268,
     FUNCTION = 269,
     MAIN = 270,
     AND = 271,
     OR = 272,
     IF = 273,
     ELSIF = 274,
     ELSE = 275,
     DO = 276,
     WHILE = 277,
     FOR = 278,
     ASSIGN = 279,
     PLUS = 280,
     MINUS = 281,
     DIVIDE = 282,
     MULTY = 283,
     PERCENT = 284,
     NE = 285,
     EQ = 286,
     GE = 287,
     LE = 288,
     GT = 289,
     LT = 290,
     RETURN = 291,
     L_K = 292,
     R_K = 293,
     L_P = 294,
     R_P = 295,
     COLON = 296,
     SEMI = 297,
     COMMA = 298
   };
#endif



#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef union YYSTYPE
{

/* Line 1676 of yacc.c  */
#line 15 ".\\lex.y"

	int    iValue; 	/* integer value */
	char   cValue; 	/* char value */
	char * sValue;  /* string value */



/* Line 1676 of yacc.c  */
#line 103 "lex.tab.h"
} YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define yystype YYSTYPE /* obsolescent; will be withdrawn */
# define YYSTYPE_IS_DECLARED 1
#endif

extern YYSTYPE yylval;


