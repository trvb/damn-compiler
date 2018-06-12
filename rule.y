/* Il faut dupliquer les déclarations préprocesseur:
    raison: parce que. */
%code requires {
    /* déclarations système */
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
    #include <stdarg.h>

    /* déclarations compilateur */
    #include "symbol_table.h"
}

%{
   /* déclarations système */
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
    #include <stdarg.h>

    /* déclarations compilateur */
    #include "symbol_table.h" 
    #include "tools.h"

    int yylex(void);
    void yyerror (char const *s) {
        fprintf (stderr, "%s\n", s);
    }

    /* crado% */
    /* Variables d'état globales du compilateur */
    /* Mémorisation du dernier type lu */
    t_type declaration_type;

    /* Mémorisation du dernier identifieur lu */
    char affect_id[256];
    void replace_id(const char* new_id) {
        memset(affect_id,'\0',256);
        strcpy(affect_id, new_id);
    }

    /* Mémorisation de la profondeur de portée */
    uint8_t scope_depth = 0;

    /* Définition fonctions utilitaires */
    void operation(const char* op) {
        uint32_t adr_src1 = get_last_pointer()-1;
        uint32_t adr_src2 = get_last_pointer();

        printf("%s de %d et %d\n", op, adr_src1, adr_src2);

        save_line("READ R1, %d", adr_src1);
        save_line("READ R2, %d", adr_src2);
        save_line("%s R1, R2", op);
        save_line("SAVE R1, %d",adr_src1);

        pop_symbol();
    }

    void affectation(const char *ident, int clear_mem) {
        printf("affectation de %s par une expr\n", ident);
        uint32_t adr_var  = get_address(ident, scope_depth);
        uint32_t adr_last = get_last_pointer();
        save_line("READ R1, %d", adr_last);
        save_line("SAVE R1, %d", adr_var);

        if(clear_mem)
            pop_symbol();

        set_initialized(affect_id, scope_depth);
    }

    /* Production de code */
    char output_code[5000][20];
    uint32_t line_pointer = 0;

    void save_line(const char* format, ...){

        char buffer[20];

        va_list argptr;
        va_start(argptr, format);
        vsprintf(buffer, format, argptr);
        va_end(argptr);
        strcpy(output_code[line_pointer], buffer);
        printf("> %s\n", buffer);

        line_pointer++; 
    }

    void print_code() {
        printf("Output instructions:\n");
        for(int i=0; i<line_pointer; i++)
            printf("\t%s\n", output_code[i]);
    }

%}

/* Déclaration des jetons */
%token tCONST;
%token tTINT;
%token tTCHAR;
%token tTVOID;
%token tCOMPEQ;
%token tCOMPNEQ;
%token tAFFECT;
%token tPRINT;
%token tID;
%token tIDSEP;
%token tCHAR;
%token tINT;
%token tSTRING;
%token tOP_PL;
%token tOP_MN;
%token tOP_ML;
%token tOP_DV;
%token tMAIN;
%token tSTSCP;
%token tNDSCP;
%token tSTGRP;
%token tNDGRP;
%token tSTARR;
%token tNDARR;
%token tEND;
%token tIF;
%token tELSE;
%token tCOMPL;
%token tCOMPLE;
%token tCOMPG;
%token tCOMPGE;

/* Déclaration des types parser/compiler */
%union { 
    int integer;
    char character;
    char identifier[256];
    t_type var_type;
};

/* Déclarations de types */
%type <integer> tINT;
%type <character> tCHAR;
%type <identifier> tID;
%type <var_type> tTINT;
%type <var_type> tTCHAR;
%type <var_type> type;
%type <integer> condt_act;

/* Priorités opératoires */
%right tAFFECT
%left tCOMPEQ tCOMPNEQ
%left tOP_PL tOP_MN
%left tOP_ML tOP_DV
%%

/* traitement routine principale */
main: tTINT tMAIN tSTGRP tNDGRP scope { printf("main\n"); };
scope: tSTSCP {
    scope_depth++;
    printf("entering new scope, depth=%d\n", scope_depth);
    } execs tNDSCP { print_table(); print_code(); };
     

/* exécution d'un scope */
execs: decl execs
    | affect execs
    | condt execs 
    | print execs
    |;

/* déclaration de variables */
decl:
    type { printf("type: %d\n", $1); }
    tID {
        replace_id($3);
        printf("déclaration de %s ", $3);
        int adr = add_symbol($3, S8BIT, scope_depth);
        printf("dans %d\n", adr);
    } decl_aff mdecl;

mdecl: tIDSEP tID {  
        replace_id($2);
        printf("(mult) déclaration de %s", $2);
        int adr = add_symbol($2, S8BIT, scope_depth);
        printf("dans %d\n", adr);        
    } decl_aff mdecl
    | tEND;

decl_aff: tAFFECT expr {
    affectation(affect_id, 1);
}
|;

condt: tIF tSTGRP expr {
    uint32_t adr_last = get_last_pointer();
    save_line("READ R0, %d", adr_last);
    save_line("JCVD R0, ??");
} tNDGRP condt_act tSTSCP execs {
    char line[20];
    sprintf(line, "JCVD R0, %d", line_pointer-1);
    strcpy(output_code[$6], line);
} tNDSCP contd_else;

contd_else: tELSE tSTSCP execs  {
    printf("On repart sur un else !\n");
} tNDSCP |;

condt_act: { $$ = line_pointer - 1; };

/* affectation */
affect: tID tAFFECT expr tEND {
    affectation($1, 1);
};

/* typage */
type: tTINT
    | tTCHAR;

/* expression arithmétique */
expr:
    expr tCOMPEQ expr {
        printf("COMPEQ\n");
        operation("EQUL");
    }
    | expr tCOMPNEQ expr {
        operation("DIFF");
    }
    | tID tAFFECT expr {
        affectation($1, 0);
    }
    | expr tCOMPG expr {
        operation("SUPR");
    }
    | expr tCOMPGE expr {
        operation("SUPE");
    }
    | expr tCOMPL expr {
        operation("INFR");
    }
    | expr tCOMPLE expr {
        operation("INFE");
    }
    | expr tOP_PL expr {
        operation("PLUS");
    }
    | expr tOP_MN expr {
        operation("SUBS");
    }
    | expr tOP_ML expr {
        operation("MULT");
    }
    | expr tOP_DV expr {
        operation("DIVX");
    }
    | tOP_MN expr %prec tOP_ML
    | tID {
        // Cas simple: copie d'une var. dans var. temp.
        printf("Copie de variable: %s\n", $1);
        uint32_t adr_src = get_address($1, scope_depth);
        uint32_t adr_new = add_symbol("#", get_type($1, scope_depth), 1);

        if(!is_initialized($1, scope_depth))
            printf(RED "/!\\ ATTENTION DUCON: %s N'EST PAS INITIALISÉE!\n" RESET, $1);

        save_line("READ R1, %d", adr_src);
        save_line("SAVE R1, %d", adr_new);
    }
    | tINT {
        printf("Expression valeur 16bit: %d\n", $1);
        uint32_t adr_new = add_symbol("#",S16BIT, 1);

        save_line("MOVE R1, %d", $1);
        save_line("SAVE R1, %d", adr_new);
    }
    | tCHAR {
        printf("Expression valeur 8bit: '%c'\n", $1);
        uint32_t adr_new = add_symbol("#",S8BIT, 1);

        save_line("MOVE R1, %d", $1);
        save_line("SAVE R1, %d", adr_new);
    };

/* affichage */

print: tPRINT tSTGRP expr tNDGRP tEND {
    uint32_t adr_src = get_last_pointer();
    save_line("READ R1, %d", adr_src);
    save_line("SHOW R1");
    pop_symbol();
};

%%

int main() {
    yyparse();
}