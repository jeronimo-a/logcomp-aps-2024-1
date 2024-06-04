%{

#include <stdio.h>

void yyerror(const char *s);
int yylex();

int default_starting_floor_value = -5;
int n_floors = -1;
int starting_floor;
FILE *DEST_FILE;

int new_floor(int selector);                // ação chamada sempre que um piso novo é identificado
int ground_floor(int selector);             // ação chamada quando o piso térreo é identificado
int write_input_vars_and_main_functions();  // ação que é chamada ao final do input, define as variáveis do input
int vardec(char *key);                      // declaração de variável

%}

%locations

%union {
    int num;
    char *str;
}

%token <num> NUMBER
%token <str> IDENT

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
%token LITERAL_PRINT_1
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
    INPUT { if (write_input_vars_and_main_functions()) { return 1; } } BLOCK
    | EOL PREBLOCK
    ;

BLOCK:
    STATEMENT EOL BLOCK     // STATEMENT seguido de um outro STATEMENT
    | STATEMENT EOL
    | STATEMENT             // STATEMENT final do BLOCK
    | /* empty */
    ;

INPUT:
    AA_ROOF EOL NEW_AA_STORY AA_GROUND_FLOOR EOL                { if (ground_floor(0)) { return 1; }; }
    | AA_ROOF EOL NEW_AA_STORY AA_GROUND_FLOOR AA_SELECTOR EOL  { if (ground_floor(1)) { return 1; }; }
    ; 

NEW_AA_STORY:
    AA_STORY EOL                                { if (new_floor(0)) { return 1; } }
    | AA_STORY AA_SELECTOR EOL                  { if (new_floor(1)) { return 1; } }
    | AA_STORY EOL NEW_AA_STORY                 { if (new_floor(0)) { return 1; } }
    | AA_STORY AA_SELECTOR EOL NEW_AA_STORY     { if (new_floor(1)) { return 1; } }
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
    | LITERAL_PRINT_STAT
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
    VARDEC_1 ASSIGN_1_VARDEC_2 IDENT VARDEC_ASSIGN B_EXPRESSION { if (vardec($3)) { return 1; } }
    | VARDEC_1 ASSIGN_1_VARDEC_2 IDENT                          { if (vardec($3)) { return 1; } }
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

LITERAL_PRINT_STAT:
    LITERAL_PRINT_1 B_EXPRESSION
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
    | IDENT
    | UNOP FACTOR
    | OPENPAR B_EXPRESSION CLOSEPAR
    | PRINT_1 PRINT_2_PESSOA
    | PRINT_1 PRINT_2_ELEVADOR
    ;

%%

int main() {

    // abre/cria o arquivo do código intermediário em Lua
    DEST_FILE = fopen("intermediate.lua", "w");
    if (DEST_FILE == NULL) {
        fprintf(stderr, "Erro ao abrir o arquivo intermediário.");
        return 1;
    }

    // inicializa o piso inicial do elevador
    starting_floor = default_starting_floor_value;

    // faz o parsing
    if (!yyparse()) {
        printf("Floors: %d\n", n_floors);
        printf("Start: %d\n", starting_floor);
        printf("Parsing bem sucedido!\n");
    } else {
        printf("Parsing mal sucedido!\n");
    }

    fclose(DEST_FILE);
    return 0;
}

yyerror(char *s) {
  fprintf(stderr, "error: %s\n", s);
}

// ação chamada quando um novo piso é identificado
int new_floor(int selector) {

    // se houver seletor no piso identificado
    if (selector) {

        // verifica se em algum outro piso anterior teve seletor
        if (starting_floor != default_starting_floor_value) {
            printf("Piso inicial definido mais de uma vez.\n");
            return 1;
        }

        // atualiza o valor do piso inicial do elevador
        starting_floor = n_floors;
    }

    // atualiza a quantidade de pisos
    n_floors++;

    return 0;
}

// ação chamada quando o piso térreo é identificado
int ground_floor(int selector) {

    // chama a subrotina que lida com um piso novo qualquer
    int result = new_floor(selector);
    if (result) { return 1; }
    
    // verifica se foi inserido o seletor
    if (starting_floor == default_starting_floor_value) {
        printf("Sem seletor da posição inicial do elevador.\n"); return 1;
    }

    // atualiza a posição inicial do elevador
    starting_floor += 2;
    if (selector) { starting_floor = 0; }

    return 0;
}

// ação chamada após a conclusão do input, define as variáveis globais da linguagem e as funções
int write_input_vars_and_main_functions() {

    // variáveis globais da linguagem
    fprintf(DEST_FILE, "local N_FLOORS = %d\n", n_floors);
    fprintf(DEST_FILE, "local STARTING_FLOOR = %d\n", starting_floor);
    fprintf(DEST_FILE, "local ELEVATOR_POSITION = STARTING_FLOOR\n");
    fprintf(DEST_FILE, "local USER_POSITION = 0\n");
    fprintf(DEST_FILE, "local IS_USER_IN_ELEVATOR = 0\n");
    fprintf(DEST_FILE, "local ELEVATOR_WANTED_POSITION = STARTING_FLOOR\n");

    // função de verificar se o usuário está no telhado
    fprintf(DEST_FILE, "function IsUserOnRoof()\n");
    fprintf(DEST_FILE, "\treturn USER_POSITION == N_FLOORS + 1\n");
    fprintf(DEST_FILE, "end\n");

    // função de verificar se o usuário está no térreo
    fprintf(DEST_FILE, "function IsUserOnGroundLevel()\n");
    fprintf(DEST_FILE, "\treturn USER_POSITION == 0\n");
    fprintf(DEST_FILE, "end\n");

    // função de subir as escadas
    fprintf(DEST_FILE, "function GoUpStairs()\n");
    fprintf(DEST_FILE, "\tif not IsUserOnRoof() then\n");
    fprintf(DEST_FILE, "\t\tUSER_POSITION = USER_POSITION + 1\n");
    fprintf(DEST_FILE, "\tend\nend\n");

    // função de descer as escadas
    fprintf(DEST_FILE, "function GoDownStairs()\n");
    fprintf(DEST_FILE, "\tif not IsUserOnGroundLevel() then\n");
    fprintf(DEST_FILE, "\t\tUSER_POSITION = USER_POSITION - 1\n");
    fprintf(DEST_FILE, "\tend\nend\n");

    // função de chamar o elevador
    fprintf(DEST_FILE, "function CallElevator(floor)\n");
    fprintf(DEST_FILE, "\tif floor > -1 and floor < N_FLOORS + 1 then\n");
    fprintf(DEST_FILE, "\t\tELEVATOR_WANTED_POSITION = floor\n");
    fprintf(DEST_FILE, "\tend\nend\n");

    // função de verificar se a posição do elevador é a mesma do usuário
    fprintf(DEST_FILE, "function IsElevatorOnUserFloor()\n");
    fprintf(DEST_FILE, "\treturn USER_POSITION == ELEVATOR_POSITION\n");
    fprintf(DEST_FILE, "end\n");

    // função de entrar no elevador
    fprintf(DEST_FILE, "function EnterElevator()\n");
    fprintf(DEST_FILE, "\tif IsElevatorOnUserFloor() then\n");
    fprintf(DEST_FILE, "\t\tIS_USER_IN_ELEVATOR = 1\n");
    fprintf(DEST_FILE, "\tend\nend\n");

    // função de movimentar o elevador
    fprintf(DEST_FILE, "function MoveElevator()\n");
    fprintf(DEST_FILE, "\tif ELEVATOR_POSITION < ELEVATOR_WANTED_POSITION then\n");
    fprintf(DEST_FILE, "\t\tELEVATOR_POSITION = ELEVATOR_POSITION + 1\n");
    fprintf(DEST_FILE, "\tend\n");
    fprintf(DEST_FILE, "\tif ELEVATOR_POSITION > ELEVATOR_WANTED_POSITION then\n");
    fprintf(DEST_FILE, "\t\tELEVATOR_POSITION = ELEVATOR_POSITION - 1\n");
    fprintf(DEST_FILE, "\tend\n");
    fprintf(DEST_FILE, "\tif IS_USER_IN_ELEVATOR then\n");
    fprintf(DEST_FILE, "\t\tUSER_POSITION = ELEVATOR_POSITION\n");
    fprintf(DEST_FILE, "\tend\nend\n");

    // função de sair do elevador
    fprintf(DEST_FILE, "function LeaveElevator()\n");
    fprintf(DEST_FILE, "\tIS_USER_IN_ELEVATOR = 0\n");
    fprintf(DEST_FILE, "end\n");

    return 0;
}

int vardec(char *key) {
    fprintf(DEST_FILE, "local %s\n", key);
    return 0;
}