
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
     V_CHAR = 261,
     V_NUMBER = 262,
     CONST = 263,
     VOID = 264,
     FUNCTION = 265,
     MAIN = 266,
     AND = 267,
     OR = 268,
     NUMBER = 269,
     STRING = 270,
     CHAR = 271,
     BOOLEAN = 272,
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
     EXP = 285,
     NE = 286,
     EQ = 287,
     GE = 288,
     LE = 289,
     GT = 290,
     LT = 291,
     RETURN = 292,
     L_K = 293,
     R_K = 294,
     L_P = 295,
     R_P = 296,
     COLON = 297,
     SEMI = 298,
     COMMA = 299
   };
#endif



#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef union YYSTYPE
{

/* Line 1676 of yacc.c  */
#line 28 ".\\lex.y"

	int    iValue; 	/* integer value */
	char   cValue; 	/* char value */
	char * sValue;  /* string value */

    struct metaData* metValue;
    struct metaDataPaF* metPaFValue;



/* Line 1676 of yacc.c  */
#line 107 "lex.tab.h"
} YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define yystype YYSTYPE /* obsolescent; will be withdrawn */
# define YYSTYPE_IS_DECLARED 1
#endif

extern YYSTYPE yylval;


