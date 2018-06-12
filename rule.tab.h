/* A Bison parser, made by GNU Bison 3.0.4.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015 Free Software Foundation, Inc.

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

#ifndef YY_YY_RULE_TAB_H_INCLUDED
# define YY_YY_RULE_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif
/* "%code requires" blocks.  */
#line 3 "rule.y" /* yacc.c:1909  */

    /* déclarations système */
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
    #include <stdarg.h>

    /* déclarations compilateur */
    #include "symbol_table.h"

#line 55 "rule.tab.h" /* yacc.c:1909  */

/* Token type.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    tCONST = 258,
    tTINT = 259,
    tTCHAR = 260,
    tTVOID = 261,
    tCOMPEQ = 262,
    tCOMPNEQ = 263,
    tAFFECT = 264,
    tPRINT = 265,
    tID = 266,
    tIDSEP = 267,
    tCHAR = 268,
    tINT = 269,
    tSTRING = 270,
    tOP_PL = 271,
    tOP_MN = 272,
    tOP_ML = 273,
    tOP_DV = 274,
    tMAIN = 275,
    tSTSCP = 276,
    tNDSCP = 277,
    tSTGRP = 278,
    tNDGRP = 279,
    tSTARR = 280,
    tNDARR = 281,
    tEND = 282,
    tIF = 283,
    tELSE = 284,
    tCOMPL = 285,
    tCOMPLE = 286,
    tCOMPG = 287,
    tCOMPGE = 288
  };
#endif

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED

union YYSTYPE
{
#line 133 "rule.y" /* yacc.c:1909  */
 
    int integer;
    char character;
    char identifier[256];
    t_type var_type;

#line 108 "rule.tab.h" /* yacc.c:1909  */
};

typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_RULE_TAB_H_INCLUDED  */
