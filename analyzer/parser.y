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
int vardec(char *key, int assign);          // declaração de variável
int assign(char *key);                      // atribuição pura de variável
int push_elevator_button(int floor);        // aperta o botão de dentro do elevador para determinado piso

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
%token WHILE_2_1
%token WHILE_2_2
%token WHILE_2_3
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
%token FREE_PRINT_1
%token OR
%token AND
%token EQUAL
%token GREATER_THAN
%token LESS_THAN
%token NOT_EQUAL
%token GREATER_EQUAL
%token LESS_EQUAL
%token NOOP
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
    STATEMENT EOL { fprintf(DEST_FILE, "\n"); } BLOCK     // STATEMENT seguido de um outro STATEMENT
    | STATEMENT EOL { fprintf(DEST_FILE, "\n"); }
    | STATEMENT { fprintf(DEST_FILE, "\n"); }             // STATEMENT final do BLOCK
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
    ADD     { fprintf(DEST_FILE, " +"); }
    | SUB   { fprintf(DEST_FILE, " -"); }
    ;

MOST_PRECEDENCE_BINOP:
    MULT    { fprintf(DEST_FILE, " *"); }
    | DIV   { fprintf(DEST_FILE, " /"); }
    ;

UNOP:
    ADD     { fprintf(DEST_FILE, " +"); }
    | SUB   { fprintf(DEST_FILE, " -"); }
    | NOT   { fprintf(DEST_FILE, " not"); }
    ;

STATEMENT:
    | ASSIGN_STAT
    | PRINT_STAT
    | WHILE_STAT
    | WHILE_STAT_2
    | IF_STAT
    | DECLARE_STAT          { fprintf(DEST_FILE, "\nend"); }
    | CALL_STAT
    | ENTER_STAT
    | LEAVE_STAT
    | PUSH_STAT
    | UP_STAT
    | DOWN_STAT
    | FREE_PRINT_STAT
    | NOOP                  { fprintf(DEST_FILE, "NoOp()"); }
    ;

// pombo IDENT agora is B_EXPRESSION
ASSIGN_STAT:
    ASSIGN_1_VARDEC_2 IDENT { if (assign($2)) { return 1; } } ASSIGN_2 ASSIGN_3 B_EXPRESSION { fprintf(DEST_FILE, "\nend ### SKIP MOVE ###"); }
    ;

PRINT_STAT:
    PRINT_1 PRINT_2_PESSOA QUESTION QUESTION QUESTION       { fprintf(DEST_FILE, "print(USER_POSITION)"); }
    | PRINT_1 PRINT_2_ELEVADOR QUESTION QUESTION QUESTION   { fprintf(DEST_FILE, "print(ELEVATOR_POSITION)"); }
    ;

// enquanto waiting elevador EOL BLOCK END
WHILE_STAT:
    WHILE_1 WHILE_2 WHILE_3_CALL_ENTER_LEAVE_2 EOL { fprintf(DEST_FILE, "while not IsElevatorOnUserFloor() do\n"); } BLOCK END { fprintf(DEST_FILE, "end"); }
    ;

// while esperando in elevador EOL BLOCK END
WHILE_STAT_2:
    WHILE_2_1 WHILE_2_2 WHILE_2_3 WHILE_3_CALL_ENTER_LEAVE_2 EOL { fprintf(DEST_FILE, "while not IsElevatorStopped() do\n"); } BLOCK END { fprintf(DEST_FILE, "end"); }

// térreo ??? EOL BLOCK END
IF_STAT:
    IF QUESTION QUESTION QUESTION EOL { fprintf(DEST_FILE, "if IsUserOnGroundLevel() then\n"); } BLOCK END { fprintf(DEST_FILE, "end"); }
    ;

// grab pombo IDENT é B_EXPRESSION ou grab pombo IDENT
DECLARE_STAT:
    VARDEC_1 ASSIGN_1_VARDEC_2 IDENT { if (vardec($3, 1)) { return 1; } } VARDEC_ASSIGN B_EXPRESSION
    | VARDEC_1 ASSIGN_1_VARDEC_2 IDENT { if (vardec($3, 0)) { return 1; } }
    ;

CALL_STAT:
    CALL_1 WHILE_3_CALL_ENTER_LEAVE_2   { fprintf(DEST_FILE, "CallElevator(USER_POSITION)"); }
    ;

ENTER_STAT:
    ENTER_1 WHILE_3_CALL_ENTER_LEAVE_2  { fprintf(DEST_FILE, "EnterElevator()"); }
    ;

LEAVE_STAT:
    LEAVE_1 WHILE_3_CALL_ENTER_LEAVE_2  { fprintf(DEST_FILE, "LeaveElevator()"); }
    ;

// push botão for o NUMBER piso ou push botão for o ground piso
PUSH_STAT:
    PUSH_BUTTON_1 PUSH_BUTTON_2 PUSH_BUTTON_3 PUSH_BUTTON_4 { fprintf(DEST_FILE, "PushElevatorButton("); } B_EXPRESSION PUSH_BUTTON_5 { fprintf(DEST_FILE, ")"); }
    | PUSH_BUTTON_1 PUSH_BUTTON_2 PUSH_BUTTON_3 PUSH_BUTTON_4 GROUND PUSH_BUTTON_5      { if (push_elevator_button(0)) { return 1; }; }
    ;

// subir stairs 
UP_STAT:
    SUBIR_ESCADA_1 SUBIR_DESCER_ESCADA_2    { fprintf(DEST_FILE, "GoUpStairs()"); }
    ;

DOWN_STAT:
    DESCER_ESCADA_1 SUBIR_DESCER_ESCADA_2   { fprintf(DEST_FILE, "GoDownStairs()"); }
    ;

FREE_PRINT_STAT:
    FREE_PRINT_1 { fprintf(DEST_FILE, "print("); } B_EXPRESSION { fprintf(DEST_FILE, ")"); }
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
    NUMBER                          { fprintf(DEST_FILE, " %d", $1); }
    | IDENT                         { fprintf(DEST_FILE, " %s", $1); }
    | UNOP FACTOR
    | OPENPAR B_EXPRESSION CLOSEPAR
    | PRINT_1 PRINT_2_PESSOA        { fprintf(DEST_FILE, " USER_POSITION"); }
    | PRINT_1 PRINT_2_ELEVADOR      { fprintf(DEST_FILE, " ELEVATOR_POSITION"); }
    ;

%%

int main() {

    // abre/cria o arquivo do código intermediário em Lua
    DEST_FILE = fopen("analyzer/.intermediate.lua", "w");
    if (DEST_FILE == NULL) {
        fprintf(stderr, "Erro ao abrir o arquivo intermediário.");
        return 1;
    }

    // inicializa o piso inicial do elevador
    starting_floor = default_starting_floor_value;

    // faz o parsing
    if (yyparse()) {
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

    // função de verificar se o elevador está no andar final
    fprintf(DEST_FILE, "function IsElevatorStopped()\n");
    fprintf(DEST_FILE, "\treturn ELEVATOR_POSITION == ELEVATOR_WANTED_POSITION\n");
    fprintf(DEST_FILE, "end\n");

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

    // função de no op
    fprintf(DEST_FILE, "function NoOp()\n");
    fprintf(DEST_FILE, "\treturn 0\n");
    fprintf(DEST_FILE, "end\n");
    
    // função de apertar o botão do elevador
    fprintf(DEST_FILE, "function PushElevatorButton(floor)\n");
    fprintf(DEST_FILE, "\tif IS_USER_IN_ELEVATOR then\n");
    fprintf(DEST_FILE, "\t\tELEVATOR_WANTED_POSITION = floor\n");
    fprintf(DEST_FILE, "\tend\nend\n");

    // sinal para o pósprocessador
    fprintf(DEST_FILE, "### SIGNAL ###\n");

    return 0;
}

int vardec(char *key, int assign) {
    fprintf(DEST_FILE, "if IsUserOnRoof() then\n");
    fprintf(DEST_FILE, "\tlocal %s", key);
    if (assign) { fprintf(DEST_FILE, " ="); }
    return 0;
}

int assign(char *key) {
    fprintf(DEST_FILE, "if IsUserOnGroundLevel() then\n");
    fprintf(DEST_FILE, "\t%s =", key);
    return 0;
}

int push_elevator_button(int floor) {
    fprintf(DEST_FILE, "PushElevatorButton(%d)\n", floor);
    return 0;
}