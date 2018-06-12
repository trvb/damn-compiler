%{
    #include "rule.tab.h"
    #include "symbol_table.h"
%}
CONST const
TYPE_INT int
TYPE_CHAR char
TYPE_VOID void

POINTER_INT {TYPE_INT}\*+
POINTER_FLOAT {TYPE_FLOAT}\*+
POINTER_CHAR {POINTER_CHAR}\*+
POINTER_VOID {POINTER_VOID}\*+

AFFECT \=
COMPEQ \=\=
COMPNEQ \!\=
COMPL   \<
COMPLE  \<\=
COMPG   \>
COMPGE  \>\=
IDSEP \,

INT [0-9]+
CHAR \'.\'
STRING \".*\"
ID [a-zA-Z][a-zA-Z0-9_]*
MAIN main
IF if
ELSE else
STSCP \{
NDSCP \}
STGRP \(
NDGRP \)
STARR \[
NDARR \]
END \;

OP_PL \+
OP_MN \-
OP_ML \*
OP_DV \/

PRINT printf

%%
{CONST} return tCONST;
{TYPE_INT} {
    yylval.var_type = S8BIT;
    return tTINT;
}
{TYPE_CHAR} {
    yylval.var_type = S8BIT;
    return tTCHAR;
}
{TYPE_VOID} return tTVOID;
{COMPNEQ} return tCOMPNEQ;
{COMPEQ} return tCOMPEQ;
{COMPL} return tCOMPL;
{COMPLE} return tCOMPLE;
{COMPG} return tCOMPG;
{COMPGE} return tCOMPGE;
{AFFECT} return tAFFECT;
{PRINT} return tPRINT;
{MAIN}  return tMAIN;
{IDSEP} return tIDSEP;
{IF} return tIF;
{ELSE} return tELSE;
{ID} {
    strcpy(yylval.identifier, yytext);
    return tID ;
}
{CHAR} {
    yylval.character = yytext[1];
    return tCHAR;
}
{INT} {
    yylval.integer = atoi(yytext);
    return tINT;
}
{STRING} return tSTRING;
{OP_PL} return tOP_PL;
{OP_MN} return tOP_MN;
{OP_ML} return tOP_ML;
{OP_DV} return tOP_DV;
{STSCP} return tSTSCP;
{NDSCP} return tNDSCP;
{STGRP} return tSTGRP;
{NDGRP} return tNDGRP;
{STARR} return tSTARR;
{NDARR} return tNDARR;
{END} return tEND;


%%
