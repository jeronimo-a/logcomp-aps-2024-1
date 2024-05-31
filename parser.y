%{
#include <stdio.h>

void yyerror(const char *s);
int yylex();
%}

%locations

%union {
    int num;
    char *str;
}

%token <num> NUMBER
%token <str> IDENT
%token <str> STRING

/* declare tokens */
%token AA_ROOF
%token AA_STORY
%token AA_GROUND_FLOOR
%token AA_SELECTOR
%token ASSIGN_1_VARDEC_2
%token ASSIGN_2
%token ASSIGN_3
%token PRINT_1
%token PRINT_2_PESSOA
%token PRINT_2_ELEVADOR
%token WHILE_1
%token WHILE_2
%token WHILE_3_CALL_ENTER_LEAVE_2
%token IF
%token QUESTION
%token VARDEC_1
%token VARDEC_ASSIGN
%token CALL_1
%token ENTER_1
%token LEAVE_1
%token PUSH_BUTTON_1
%token PUSH_BUTTON_2
%token PUSH_BUTTON_3
%token PUSH_BUTTON_4
%token PUSH_BUTTON_5
%token SUBIR_ESCADA_1
%token DESCER_ESCADA_1
%token SUBIR_DESCER_ESCADA_2
%token OR
%token AND
%token EQUAL
%token GREATER_THAN
%token LESS_THAN
%token NOT_EQUAL
%token GREATER_EQUAL
%token LESS_EQUAL
%token ADD
%token SUB
%token CAT
%token MULT
%token DIV
%token NOT
%token OPENPAR
%token CLOSEPAR
%token GROUND
%token ORDINAL
%token TAB
%token EOL
%token END

%%

PREBLOCK:
    INPUT BLOCK
    | EOL PREBLOCK
    ;

BLOCK:
    STATEMENT EOL BLOCK     // STATEMENT seguido de um outro STATEMENT
    | STATEMENT EOL
    | STATEMENT             // STATEMENT final do BLOCK
    | /* empty */
    ;

INPUT:
    AA_ROOF EOL NEW_AA_STORY AA_GROUND_FLOOR EOL
    | AA_ROOF EOL NEW_AA_STORY AA_GROUND_FLOOR AA_SELECTOR EOL
    ;

NEW_AA_STORY:
    AA_STORY EOL
    | AA_STORY AA_SELECTOR EOL
    | AA_STORY EOL NEW_AA_STORY
    | AA_STORY AA_SELECTOR EOL NEW_AA_STORY
    ;

COMPARATOR:
    EQUAL
    | NOT_EQUAL
    | LESS_THAN
    | LESS_EQUAL
    | GREATER_THAN
    | GREATER_EQUAL
    ;

LEAST_PRECENDECE_BINOP:
    ADD
    | SUB
    | CAT
    ;

MOST_PRECEDENCE_BINOP:
    MULT
    | DIV
    ;

UNOP:
    ADD
    | SUB
    | NOT
    ;

STATEMENT:
    | ASSIGN_STAT
    | PRINT_STAT
    | WHILE_STAT
    | IF_STAT
    | DECLARE_STAT
    | CALL_STAT
    | ENTER_STAT
    | LEAVE_STAT
    | PUSH_STAT
    | UP_STAT
    | DOWN_STAT
    ;

// pombo IDENT agora is B_EXPRESSION
ASSIGN_STAT:
    ASSIGN_1_VARDEC_2 IDENT ASSIGN_2 ASSIGN_3 B_EXPRESSION
    ;

PRINT_STAT:
    PRINT_1 PRINT_2_PESSOA QUESTION QUESTION QUESTION
    | PRINT_1 PRINT_2_ELEVADOR QUESTION QUESTION QUESTION
    ;

// enquanto waiting elevador EOL BLOCK END
WHILE_STAT:
    WHILE_1 WHILE_2 WHILE_3_CALL_ENTER_LEAVE_2 EOL BLOCK END
    ;

// térreo ??? EOL BLOCK END
IF_STAT:
    IF QUESTION QUESTION QUESTION EOL BLOCK END
    ;

// grab pombo IDENT é B_EXPRESSION ou grab pombo IDENT
DECLARE_STAT:
    VARDEC_1 ASSIGN_1_VARDEC_2 IDENT VARDEC_ASSIGN B_EXPRESSION
    | VARDEC_1 ASSIGN_1_VARDEC_2 IDENT
    ;

CALL_STAT:
    CALL_1 WHILE_3_CALL_ENTER_LEAVE_2
    ;

ENTER_STAT:
    ENTER_1 WHILE_3_CALL_ENTER_LEAVE_2
    ;

LEAVE_STAT:
    LEAVE_1 WHILE_3_CALL_ENTER_LEAVE_2
    ;

// push botão for o NUMBER piso ou push botão for o ground piso
PUSH_STAT:
    PUSH_BUTTON_1 PUSH_BUTTON_2 PUSH_BUTTON_3 PUSH_BUTTON_4 NUMBER PUSH_BUTTON_5
    | PUSH_BUTTON_1 PUSH_BUTTON_2 PUSH_BUTTON_3 PUSH_BUTTON_4 GROUND PUSH_BUTTON_5
    ;

// subir stairs 
UP_STAT:
    SUBIR_ESCADA_1 SUBIR_DESCER_ESCADA_2
    ;

DOWN_STAT:
    DESCER_ESCADA_1 SUBIR_DESCER_ESCADA_2
    ;

B_EXPRESSION:
    B_TERM OR B_EXPRESSION
    | B_TERM
    ;

B_TERM:
    R_EXPRESSION AND B_TERM
    | R_EXPRESSION
    ;

R_EXPRESSION:
    EXPRESSION COMPARATOR R_EXPRESSION
    | EXPRESSION
    ;

EXPRESSION:
    TERM LEAST_PRECENDECE_BINOP EXPRESSION
    | TERM
    ;

TERM:
    FACTOR MOST_PRECEDENCE_BINOP TERM
    | FACTOR
    ;

FACTOR:
    NUMBER
    | STRING
    | IDENT
    | UNOP FACTOR
    | OPENPAR B_EXPRESSION CLOSEPAR
    | PRINT_1 PRINT_2_PESSOA
    | PRINT_1 PRINT_2_ELEVADOR
    ;

%%

int main() {
    if (!yyparse()) {
        printf("Parsing successful!\n");
    } else {
        printf("Parsing failed!\n");
    }
    return 0;
}

yyerror(char *s)
{
  fprintf(stderr, "error: %s\n", s);
}